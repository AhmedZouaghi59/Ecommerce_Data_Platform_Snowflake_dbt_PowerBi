SELECT DISTINCT
    "Ship Mode" AS ship_mode
FROM {{ source('raw', 'raw_superstore') }}
WHERE "Ship Mode" IS NOT NULL