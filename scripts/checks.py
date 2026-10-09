import duckdb

con = duckdb.connect("telecom_churn.duckdb", read_only=True)

print("\n== Negative monthly charges ==")
con.sql("select count(*) as n from stg_customer_churn where monthly_charge < 0").show()

print("== Customers with zip not found in population table ==")
con.sql("""
    select count(*) as n
    from stg_customer_churn c
    left join stg_zipcode_population z on c.zip_code = z.zip_code
    where z.zip_code is null
""").show()

print("== Offer distribution ==")
con.sql("select offer, count(*) as n from stg_customer_churn group by 1 order by 2 desc").show()

print("== Status distribution ==")
con.sql("select customer_status, count(*) as n from stg_customer_churn group by 1 order by 2 desc").show()
print("== Rows in intermediate (expect 7043) ==")
con.sql("select count(*) as n from int_customer_enriched").show()

print("== Churn rate by tenure band ==")
con.sql("""
    select tenure_band,
           count(*) as customers,
           sum(is_churned::int) as churned,
           round(100.0 * avg(is_churned::int), 1) as churn_pct
    from int_customer_enriched
    group by 1
    order by min(tenure_in_months)
""").show()
print("== Churn by contract ==")
con.sql("select contract_type, sum(total_customers) c, round(100.0*sum(churned_customers)/sum(total_customers),1) churn_pct from rpt_churn_by_contract group by 1 order by 3 desc").show()

print("== Top churn reasons ==")
con.sql("select churn_category, churn_reason, churned_customers, pct_of_all_churn from rpt_churn_reasons limit 8").show()

print("== Highest churn segments (min 100 customers) ==")
con.sql("select dimension, segment, total_customers, churn_rate_pct from rpt_churn_by_demographics where total_customers >= 100 order by churn_rate_pct desc limit 10").show()
print("== Churn by contract ==")
con.sql("""
    select contract_type,
           sum(total_customers) as customers,
           round(100.0 * sum(churned_customers) / sum(total_customers), 1) as churn_pct
    from rpt_churn_by_contract
    group by 1 order by 3 desc
""").show()

print("== Churn by internet type ==")
con.sql("""
    select internet_type,
           sum(total_customers) as customers,
           round(100.0 * sum(churned_customers) / sum(total_customers), 1) as churn_pct
    from rpt_churn_by_contract
    group by 1 order by 3 desc
""").show()

print("== Top churn reasons ==")
con.sql("""
    select churn_category, churn_reason, churned_customers, pct_of_all_churn
    from rpt_churn_reasons limit 8
""").show()

print("== Highest churn segments (min 100 customers) ==")
con.sql("""
    select dimension, segment, total_customers, churn_rate_pct
    from rpt_churn_by_demographics
    where total_customers >= 100
    order by churn_rate_pct desc limit 10
""").show()

print("== Geography: top 5 zip codes by churn ==")
con.sql("""
    select city, zip_code, total_customers, churn_rate_pct
    from rpt_churn_by_geography limit 5
""").show()