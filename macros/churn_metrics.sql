{% macro churn_metrics() %}
    count(*)                                              as total_customers,
    sum(is_churned::int)                                  as churned_customers,
    round(100.0 * avg(is_churned::int), 2)                as churn_rate_pct,
    round(avg(monthly_charge_clean), 2)                   as avg_monthly_charge,
    round(avg(tenure_in_months), 1)                       as avg_tenure_months,
    round(sum(total_revenue), 2)                          as total_revenue,
    round(sum(case when is_churned then total_revenue else 0 end), 2) as revenue_from_churned
{% endmacro %}