select
    cast("Zip Code" as varchar) as zip_code,
    "Population"                as population
from {{ ref('telecom_zipcode_population') }}