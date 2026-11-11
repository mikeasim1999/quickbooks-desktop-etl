SELECT
    sir.TxnID AS item_receipt_id
    ,CASE WHEN sir.VendorRef_ListID = '' THEN '0' ELSE sir.VendorRef_ListID END AS vendor_id
    ,CASE WHEN sir.APAccountRef_ListID = '' THEN '0' ELSE sir.APAccountRef_ListID END AS account_id

    ,CAST(sir.TxnDate AS DATE) AS transaction_date

    ,CAST(sir.TxnNumber AS INT) AS transaction_number

    ,NULLIF(sir.Memo, '') AS memo

    ,CASE WHEN sir.VendorRef_FullName = '' THEN 'Unassigned' ELSE sir.VendorRef_FullName END AS vendor_full_name
    ,CASE WHEN sir.APAccountRef_FullName = '' THEN 'Unassigned' ELSE sir.APAccountRef_FullName END AS ap_account_full_name
    
    ,CAST(sir.TotalAmount AS DECIMAL(12,4)) AS total_amount
    
    ,NULLIF(sir.EditSequence, '') AS edit_sequence
    ,CAST(sir.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sir.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sir.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_receipt AS sir
-- << INCREMENTAL >> --
WHERE
  CAST(sir.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  