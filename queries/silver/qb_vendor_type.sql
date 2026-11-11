WITH source AS (
    SELECT
        svt.ListID AS vendor_type_id

        ,svt.Name AS vendor_type_name
        ,svt.FullName AS vendor_type_full_name

        ,CAST(svt.IsActive AS BOOLEAN) AS is_active

        ,svt.Sublevel AS sublevel

        ,NULLIF(svt.EditSequence, '') AS edit_sequence
        ,CAST(svt.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(svt.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(svt.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendor_type AS svt

    UNION ALL

    SELECT
        '0', 'Unassigned', 'Unassigned',
        TRUE,
        NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'
  