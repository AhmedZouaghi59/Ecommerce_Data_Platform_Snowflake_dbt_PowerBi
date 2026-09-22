{{ config(
    schema='SEM',
    materialized='view'
) }}

SELECT
    TRIM(country) AS "Country",
    TRIM(city) AS "City",
    TRIM(state) AS "State",
    postal_code AS "Postal Code",
    TRIM(region) AS "Region"

FROM {{ ref('dim_location_dwh') }}

WHERE country IS NOT NULL
  AND TRIM(country) <> ''