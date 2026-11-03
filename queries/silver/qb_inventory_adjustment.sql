SELECT
    sia.TxnID AS inventory_adjustment_id
    ,CASE WHEN sia.AccountRef_ListID = '' THEN '0' ELSE sia.AccountRef_ListID END AS account_id
    ,CASE WHEN sia.CustomerRef_ListID = '' THEN '0' ELSE sia.CustomerRef_ListID END AS customer_id
    ,CASE WHEN sia.ClassRef_ListID = '' THEN '0' ELSE sia.ClassRef_ListID END AS class_id

    ,CAST(sia.TxnDate AS DATE) AS transaction_date

    ,CAST(sia.TxnNumber AS INT) AS transaction_number
    ,NULLIF(sia.RefNumber, '') AS reference_number
    
    ,NULLIF(sia.Memo, '') AS memo

    ,CASE WHEN sia.AccountRef_FullName = '' THEN 'Unassigned' ELSE sia.AccountRef_FullName END AS account_full_name
    ,CASE WHEN sia.CustomerRef_FullName = '' THEN 'Unassigned' ELSE sia.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN sia.ClassRef_FullName = '' THEN 'Unassigned' ELSE sia.ClassRef_FullName END AS class_full_name

    ,NULLIF(sia.EditSequence, '') AS edit_sequence
    ,CAST(sia.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sia.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sia.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_inventory_adjustment AS sia
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_inventory_adjustment AS tia
    ON sia.TxnID = tia.inventory_adjustment_id
WHERE
  (
    tia.inventory_adjustment_id IS NULL
    OR CAST(sia.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )