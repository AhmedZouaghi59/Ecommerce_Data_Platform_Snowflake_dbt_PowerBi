SELECT DISTINCT
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    "Segment" AS segment
FROM {{ source('raw', 'raw_superstore') }}
WHERE "Customer ID" IS NOT NULL