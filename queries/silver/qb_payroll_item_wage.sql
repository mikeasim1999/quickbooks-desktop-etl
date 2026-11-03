WITH source AS (
    SELECT
        spiw.ListID AS payroll_item_wage_id
        ,CASE WHEN spiw.ExpenseAccountRef_ListID = '' THEN '0' ELSE spiw.ExpenseAccountRef_ListID END AS expense_account_id

        ,spiw.Name AS payroll_item_wage_name

        ,CAST(spiw.IsActive AS BOOLEAN) AS is_active

        ,TRIM(REGEXP_REPLACE(spiw.WageType, '([A-Z])', ' $1')) AS wage_type
        
        ,CASE WHEN spiw.ExpenseAccountRef_FullName = '' THEN 'Unassigned' ELSE spiw.ExpenseAccountRef_FullName END AS expense_account_full_name

        ,NULLIF(spiw.EditSequence, '') AS edit_sequence
        ,CAST(spiw.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(spiw.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(spiw.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_payroll_item_wage AS spiw

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
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_payroll_item_wage AS tpiw
    ON src.payroll_item_wage_id = tpiw.payroll_item_wage_id
WHERE
  (
    tpiw.payroll_item_wage_id IS NULL
    OR src.last_modified_datetime >= '{WATERMARK_DATE}'
  )