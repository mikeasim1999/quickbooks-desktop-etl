SELECT
    sd.TxnID AS deposit_id
    ,CASE WHEN sd.DepositToAccountRef_ListID = '' THEN '0' ELSE sd.DepositToAccountRef_ListID END AS account_id

    ,CAST(sd.TxnDate AS DATE) AS transaction_date
    
    ,CAST(sd.TxnNumber AS INT) AS transaction_number

    ,CASE WHEN sd.DepositToAccountRef_FullName = '' THEN 'Unassigned' ELSE sd.DepositToAccountRef_FullName END AS account_name

    ,NULLIF(sd.Memo, '') AS memo

    ,CAST(sd.DepositTotal AS DECIMAL(12,4)) AS deposit_amount

    ,NULLIF(sd.EditSequence, '') AS edit_sequence
    ,CAST(sd.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sd.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sd.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_deposit AS sd
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_customer_type AS td
    ON sd.TxnID = td.deposit_id
WHERE
  (
    td.deposit_id IS NULL
    OR CAST(sd.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )