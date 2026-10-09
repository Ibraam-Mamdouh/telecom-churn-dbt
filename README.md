# Telecom Customer Churn – dbt Project

dbt project (DuckDB) that cleans telecom customer data and builds reporting
models to identify which customers are most likely to churn.

## Data sources (seeds)
- `telecom_customer_churn` – 7,043 customers (demographics, services, charges, status)
- `telecom_zipcode_population` – population per zip code

## Project structure
| Layer | Models | Purpose |
|---|---|---|
| Staging | `stg_customer_churn`, `stg_zipcode_population` | Rename columns to snake_case, fill logical NULLs, add `is_churned` |
| Intermediate | `int_customer_enriched` | Join zip population; add tenure/age/population/referral bands, add-on count, negative-charge flag |
| Marts | `rpt_churn_by_contract`, `rpt_churn_by_demographics`, `rpt_churn_reasons`, `rpt_churn_by_geography` | Churn reporting |

The macro `churn_metrics()` keeps the aggregation logic consistent across reports.

## Key assumptions
- `Joined` customers (454) are counted as not churned.
- 120 customers have a negative `monthly_charge`; they are flagged
  (`has_negative_monthly_charge`) and excluded from averages via `monthly_charge_clean`.
- Missing internet add-on values mean no internet service, so they are filled with `No` / `No Internet`.
- Geography report only includes zip codes with at least 10 customers.

## How to run
```bash
dbt seed
dbt run
dbt test
dbt docs generate
```

## Key findings
- Overall churn: ~26.5%.
- Month-to-Month contracts churn at 45.8% vs 2.5% for Two Year.
- Churn falls with tenure: 53.3% (0-6 months) down to 9.5% (49+ months).
- Fiber Optic has the highest churn among internet types (40.7%).
- Competitors account for 45% of churn reasons; price only ~11%.
- The highest-churn zip codes are all in San Diego (small samples, needs investigation).
- Findings are correlations, not proven causes.