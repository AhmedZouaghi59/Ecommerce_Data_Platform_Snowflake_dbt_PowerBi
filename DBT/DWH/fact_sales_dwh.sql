SELECT
    "Row ID" AS row_id,
    "Order ID" AS order_id,
    "Order Date" AS order_date,
    "Ship Date" AS ship_date,
    "Ship Mode" AS ship_mode,
    "Customer ID" AS customer_id,
    "Product ID" AS product_id,
    "Country" AS country,
    "City" AS city,
    "State" AS state,
    "Postal Code" AS postal_code,
    "Region" AS region,
    "Sales" AS sales,
    "Quantity" AS quantity,
    "Discount" AS discount,
    "Profit" AS profit
FROM {{ source('raw', 'raw_superstore') }}
WHERE "Order ID" IS NOT NULL