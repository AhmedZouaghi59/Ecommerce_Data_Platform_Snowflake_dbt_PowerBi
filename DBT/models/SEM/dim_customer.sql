{{ config(
    schema='SEM',
    materialized='view'
) }}

SELECT
    TRIM(customer_id) AS "Customer ID",
    TRIM(customer_name) AS "Customer Name",
    TRIM(segment) AS "Segment"

FROM {{ ref('dim_customer_dwh') }}

WHERE customer_id IS NOT NULL
  AND TRIM(customer_id) <> ''