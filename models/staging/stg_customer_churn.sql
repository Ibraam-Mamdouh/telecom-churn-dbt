with source as (

    select * from {{ ref('telecom_customer_churn') }}

),

renamed as (

    select
        "Customer ID"                          as customer_id,
        "Gender"                               as gender,
        "Age"                                  as age,
        "Married"                              as is_married,
        "Number of Dependents"                 as number_of_dependents,
        "City"                                 as city,
        cast("Zip Code" as varchar)            as zip_code,
        "Latitude"                             as latitude,
        "Longitude"                            as longitude,
        "Number of Referrals"                  as number_of_referrals,
        "Tenure in Months"                     as tenure_in_months,
        coalesce(nullif("Offer", ''), 'None')  as offer,

        "Phone Service"                        as has_phone_service,
        coalesce("Avg Monthly Long Distance Charges", 0) as avg_monthly_long_distance_charges,
        coalesce("Multiple Lines", 'No')       as has_multiple_lines,

        "Internet Service"                     as has_internet_service,
        coalesce("Internet Type", 'No Internet') as internet_type,
        coalesce("Avg Monthly GB Download", 0) as avg_monthly_gb_download,
        coalesce("Online Security", 'No')      as has_online_security,
        coalesce("Online Backup", 'No')        as has_online_backup,
        coalesce("Device Protection Plan", 'No') as has_device_protection,
        coalesce("Premium Tech Support", 'No') as has_premium_tech_support,
        coalesce("Streaming TV", 'No')         as has_streaming_tv,
        coalesce("Streaming Movies", 'No')     as has_streaming_movies,
        coalesce("Streaming Music", 'No')      as has_streaming_music,
        coalesce("Unlimited Data", 'No')       as has_unlimited_data,

        "Contract"                             as contract_type,
        "Paperless Billing"                    as has_paperless_billing,
        "Payment Method"                       as payment_method,

        "Monthly Charge"                       as monthly_charge,
        "Total Charges"                        as total_charges,
        "Total Refunds"                        as total_refunds,
        "Total Extra Data Charges"             as total_extra_data_charges,
        "Total Long Distance Charges"          as total_long_distance_charges,
        "Total Revenue"                        as total_revenue,

        "Customer Status"                      as customer_status,
        coalesce("Churn Category", 'Not Churned') as churn_category,
        coalesce("Churn Reason", 'Not Churned')   as churn_reason,

        ("Customer Status" = 'Churned')        as is_churned

    from source

)

select * from renamed