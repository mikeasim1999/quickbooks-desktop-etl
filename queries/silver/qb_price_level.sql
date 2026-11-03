WITH source AS (
    SELECT
        spl.ListID AS price_level_id

        ,spl.Name AS price_level_name

        ,CAST(spl.IsActive AS BOOLEAN) AS is_active

        ,TRIM(REGEXP_REPLACE(spl.PriceLevelType, '([A-Z])', ' $1')) AS price_level_type

        ,TRY_CAST(spl.PriceLevelFixedPercentage AS DECIMAL(6,4)) AS price_level_fixed_percentage
        ,TRY_CAST(spl.PriceLevelFixedPercentage AS DECIMAL(4,2)) / 100 AS price_level_fixed_decimal

        ,NULLIF(spl.EditSequence, '') AS edit_sequence
        ,CAST(spl.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(spl.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(spl.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_price_level AS spl

    UNION ALL

    SELECT
        '0', 'Unassigned',
        TRUE,
        NULL,
        NULL, NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_price_level AS tpl
    ON src.price_level_id = tpl.price_level_id
WHERE
  (
    tpl.price_level_id IS NULL
    OR src.last_modified_datetime >= '{WATERMARK_DATE}'
  )