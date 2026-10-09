select
    city,
    zip_code,
    zip_population,
    zip_population_band,
    {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }}
group by 1, 2, 3, 4
having count(*) >= 10
order by churn_rate_pct desc