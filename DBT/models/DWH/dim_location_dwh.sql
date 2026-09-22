SELECT DISTINCT
    "Country" AS country,
    "City" AS city,
    "State" AS state,
    "Postal Code" AS postal_code,
    "Region" AS region
FROM {{ source('raw', 'raw_superstore') }}
WHERE "Country" IS NOT NULL