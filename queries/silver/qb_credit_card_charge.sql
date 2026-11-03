SELECT
    sccc.TxnID AS credit_card_charge_id
    ,CASE WHEN sccc.AccountRef_ListID = '' THEN '0' ELSE sccc.AccountRef_ListID END AS account_id
    ,CASE WHEN sccc.PayeeEntityRef_ListID = '' THEN '0' ELSE sccc.PayeeEntityRef_ListID END AS vendor_id

    ,CAST(sccc.TxnDate AS DATE) AS transaction_date

    ,CAST(sccc.TxnNumber AS INT) AS transaction_number

    ,CASE WHEN sccc.AccountRef_FullName = '' THEN 'Unassigned' ELSE sccc.AccountRef_FullName END AS account_full_name
    ,CASE WHEN sccc.PayeeEntityRef_FullName = '' THEN 'Unassigned' ELSE sccc.PayeeEntityRef_FullName END AS vendor_full_name
    
    ,CAST(sccc.Amount AS DECIMAL(12,4)) AS amount

    ,NULLIF(sccc.EditSequence, '') AS edit_sequence
    ,CAST(sccc.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sccc.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sccc.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_card_charge AS sccc
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_credit_card_charge AS tccc
    ON sccc.TxnID = tccc.credit_card_charge_id
WHERE
  (
    tccc.credit_card_charge_id IS NULL
    OR CAST(sccc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )