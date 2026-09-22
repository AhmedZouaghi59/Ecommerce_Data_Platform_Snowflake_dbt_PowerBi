WITH products AS (

    SELECT
        "Product ID" AS product_id,
        "Product Name" AS product_name,
        "Category" AS category,
        "Sub-Category" AS sub_category,

        ROW_NUMBER() OVER (
            PARTITION BY "Product ID"
            ORDER BY "Product Name"
        ) AS rn

    FROM {{ source('raw', 'raw_superstore') }}

    WHERE "Product ID" IS NOT NULL

)

SELECT
    product_id,
    product_name,
    category,
    sub_category
FROM products
WHERE rn = 1