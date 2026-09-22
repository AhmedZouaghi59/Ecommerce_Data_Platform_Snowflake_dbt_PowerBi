{{ config(
    schema='SEM',
    materialized='view'
) }}

SELECT DISTINCT
    TRIM(ship_mode) AS "Ship Mode"

FROM {{ ref('dim_shipping_dwh') }}

WHERE ship_mode IS NOT NULL
  AND TRIM(ship_mode) <> ''