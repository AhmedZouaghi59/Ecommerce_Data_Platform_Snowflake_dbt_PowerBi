{{ config(
    schema='SEM',
    materialized='view'
) }}

SELECT
    row_id AS "Row ID",
    order_id AS "Order ID",

    CAST(order_date AS DATE) AS "Order Date",
    CAST(ship_date AS DATE) AS "Ship Date",

    TRIM(ship_mode) AS "Ship Mode",

    TRIM(customer_id) AS "Customer ID",
    TRIM(product_id) AS "Product ID",

    TRIM(country) AS "Country",
    TRIM(city) AS "City",
    TRIM(state) AS "State",
    postal_code AS "Postal Code",
    TRIM(region) AS "Region",

    CAST(sales AS NUMBER(18,4)) AS "Sales",
    CAST(quantity AS INTEGER) AS "Quantity",
    CAST(ROUND(discount, 2) AS NUMBER(5,2)) AS "Discount",
    CAST(profit AS NUMBER(18,4)) AS "Profit"

FROM {{ ref('fact_sales_dwh') }}