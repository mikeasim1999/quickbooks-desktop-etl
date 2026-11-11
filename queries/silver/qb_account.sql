WITH source AS (
    SELECT
        sa.ListID AS account_id
        ,NULLIF(sa.TaxLineInfoRet_TaxLineID, '') AS tax_line_id
        ,sa.Name AS account_name
        ,sa.FullName AS account_full_name
        ,SUBSTRING_INDEX(sa.FullName, ':', 1) AS account_parent_name
        ,TRY_CAST(sa.AccountNumber AS int) AS account_number
        ,CONCAT_WS(' ', sa.AccountNumber, sa.Name) AS account_display_name
        ,TRIM(REGEXP_REPLACE(sa.AccountType, '([A-Z])', ' $1')) AS account_type
        ,NULLIF(sa.Desc, '') AS account_description
        ,NULLIF(sa.CashFlowClassification, '') AS cash_flow_classification
        ,CAST(sa.Sublevel AS INT) AS sublevel
        ,CAST(sa.IsActive AS BOOLEAN) AS is_active
        ,CASE
            WHEN LEFT(TRY_CAST(sa.AccountNumber AS INT), 1) <= 3
                THEN TRUE
            ELSE FALSE
        END AS is_balance_sheet
        ,CAST(sa.Balance AS DECIMAL(12, 4)) AS balance
        ,CAST(sa.TotalBalance AS DECIMAL(12, 4)) AS total_balance  
        ,NULLIF(sa.TaxLineInfoRet_TaxLineName, '') AS tax_line_name
        ,NULLIF(sa.EditSequence, '') AS edit_sequence
        ,CAST(sa.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sa.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sa.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_account AS sa

    UNION ALL

    SELECT
        '0', NULL, 'Unassigned', 'Unassigned', 'Unassigned',
        0, '0 Unassigned', 'Unassigned', NULL, NULL,
        0, TRUE, FALSE,
        CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)),
        NULL, NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'