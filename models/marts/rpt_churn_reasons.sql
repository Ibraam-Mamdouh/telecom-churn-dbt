select
    churn_category,
    churn_reason,
    count(*)                                                       as churned_customers,
    round(100.0 * count(*) / sum(count(*)) over (), 2)             as pct_of_all_churn,
    round(avg(monthly_charge_clean), 2)                            as avg_monthly_charge,
    round(avg(tenure_in_months), 1)                                as avg_tenure_months
from {{ ref('int_customer_enriched') }}
where is_churned
group by 1, 2
order by churned_customers desc