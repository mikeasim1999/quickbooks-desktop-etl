WITH source AS (
    SELECT
        spinw.ListID AS payroll_item_nonwage_id
        ,CASE WHEN spinw.ExpenseAccountRef_ListID = '' THEN '0' ELSE spinw.ExpenseAccountRef_ListID END AS expense_account_id

        ,spinw.Name AS payroll_item_nonwage_name

        ,CAST(spinw.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(spinw.NonWageType, '') AS nonwage_type

        ,CASE WHEN spinw.ExpenseAccountRef_FullName = '' THEN 'Unassigned' ELSE spinw.ExpenseAccountRef_FullName END AS expense_account_full_name

        ,NULLIF(spinw.EditSequence, '') AS edit_sequence
        ,CAST(spinw.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(spinw.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(spinw.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_payroll_item_nonwage AS spinw

    UNION ALL

    SELECT
        '0', '0',
        'Unassigned',
        TRUE,
        NULL,
        'Unassigned',
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'
  