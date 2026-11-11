WITH source AS (
    SELECT
        sct.ListID AS customer_type_id

        ,sct.Name AS customer_type
        ,sct.FullName AS customer_type_full

        ,CAST(sct.Sublevel AS INT) AS sublevel
        ,CAST(sct.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(sct.EditSequence, '') AS edit_sequence
        ,CAST(sct.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sct.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sct.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_customer_type AS sct

    UNION ALL

    SELECT
        '0', 'Unassigned', 'Unassigned',
        0, TRUE,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'
  