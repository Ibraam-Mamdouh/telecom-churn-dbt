with customers as (

    select * from {{ ref('stg_customer_churn') }}

),

zip_population as (

    select * from {{ ref('stg_zipcode_population') }}

),

joined as (

    select
        c.*,
        z.population as zip_population
    from customers c
    left join zip_population z
        on c.zip_code = z.zip_code

),

enriched as (

    select
        *,

        -- data quality flag: negative charges are not valid
        (monthly_charge < 0) as has_negative_monthly_charge,
        case when monthly_charge < 0 then null else monthly_charge end as monthly_charge_clean,

        -- segments
        case
            when tenure_in_months <= 6  then '0-6 months'
            when tenure_in_months <= 12 then '7-12 months'
            when tenure_in_months <= 24 then '13-24 months'
            when tenure_in_months <= 48 then '25-48 months'
            else '49+ months'
        end as tenure_band,

        case
            when age < 30 then 'Under 30'
            when age < 50 then '30-49'
            when age < 65 then '50-64'
            else '65+'
        end as age_group,

        case
            when zip_population is null  then 'Unknown'
            when zip_population < 10000  then 'Under 10k'
            when zip_population < 30000  then '10k-30k'
            else '30k+'
        end as zip_population_band,

        case
            when number_of_referrals = 0 then 'No referrals'
            when number_of_referrals <= 3 then '1-3 referrals'
            else '4+ referrals'
        end as referral_band,

        -- how many add-on services the customer has
        (
            (has_online_security = 'Yes')::int
            + (has_online_backup = 'Yes')::int
            + (has_device_protection = 'Yes')::int
            + (has_premium_tech_support = 'Yes')::int
            + (has_unlimited_data = 'Yes')::int
        ) as add_on_service_count

    from joined

)

select * from enriched