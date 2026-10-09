select
    contract_type,
    internet_type,
    {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }}
group by 1, 2
order by contract_type, churn_rate_pct desc