select 'age_group' as dimension, age_group as segment, {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }} group by 1, 2

union all

select 'gender', gender, {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }} group by 1, 2

union all

select 'married', is_married, {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }} group by 1, 2

union all

select 'tenure_band', tenure_band, {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }} group by 1, 2

union all

select 'referral_band', referral_band, {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }} group by 1, 2

union all

select 'offer', offer, {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }} group by 1, 2

union all

select 'add_on_service_count', add_on_service_count::varchar, {{ churn_metrics() }}
from {{ ref('int_customer_enriched') }} group by 1, 2

order by dimension, churn_rate_pct desc