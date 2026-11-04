WITH source AS (
    SELECT
        sjt.ListID AS job_type_id
        ,sjt.Name AS job_type_name
        ,sjt.FullName AS job_type_full_name
        ,CAST(sjt.IsActive AS BOOLEAN) AS is_active
        ,TRY_CAST(sjt.Sublevel AS INT) AS sublevel

        ,NULLIF(sjt.EditSequence, '') AS edit_sequence
        ,CAST(sjt.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sjt.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sjt.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_job_type AS sjt

    UNION ALL

    SELECT
        '0', 'Unassigned', 'Unassigned',
        TRUE, NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_job_type AS tjt
    ON src.job_type_id = tjt.job_type_id
WHERE
  (
    tjt.job_type_id IS NULL
    OR src.last_modified_datetime >= '{WATERMARK_DATE}'
  )