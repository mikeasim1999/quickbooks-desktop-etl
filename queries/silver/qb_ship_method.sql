WITH source AS (
    SELECT
        ssm.ListID AS ship_method_id

        ,ssm.Name AS ship_method_name
        ,CAST(ssm.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(ssm.EditSequence, '') AS edit_sequence
        ,CAST(ssm.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(ssm.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(ssm.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_ship_method AS ssm

    UNION ALL

    SELECT
        '0', 'Unassigned',
        TRUE,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'