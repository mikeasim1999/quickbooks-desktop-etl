WITH source AS (
    SELECT
        sc.ListID AS class_id
        ,sc.Name AS class_name
        ,sc.FullName AS full_class_name
        ,CAST(sc.IsActive AS BOOLEAN) AS is_active
        ,TRY_CAST(sc.Sublevel AS INT) AS sublevel
        ,NULLIF(sc.EditSequence, '') AS edit_sequence
        ,CAST(sc.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sc.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sc.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_class AS sc

    UNION ALL

    SELECT
        '0', 'Unassigned', 'Unassigned',
        TRUE, 0, NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_class AS tc
    ON src.class_id = tc.class_id
WHERE
  (
    tc.class_id IS NULL
    OR src.last_modified_datetime >= '{WATERMARK_DATE}'
  )