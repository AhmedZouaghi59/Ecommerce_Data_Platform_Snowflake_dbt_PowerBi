{{ config(
    schema='SEM',
    materialized='view'
) }}

SELECT
    TRIM(product_id) AS "Product ID",
    TRIM(product_name) AS "Product Name",
    TRIM(category) AS "Category",
    TRIM(sub_category) AS "Sub-Category"

FROM {{ ref('dim_product_dwh') }}

WHERE product_id IS NOT NULL
  AND TRIM(product_id) <> ''