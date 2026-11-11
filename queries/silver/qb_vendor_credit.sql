SELECT
    svc.TxnID AS vendor_credit_id
    ,CASE WHEN svc.VendorRef_ListID = '' THEN '0' ELSE svc.VendorRef_ListID END AS vendor_id
    ,CASE WHEN svc.APAccountRef_ListID = '' THEN '0' ELSE svc.APAccountRef_ListID END AS account_id

    ,CAST(svc.Txndate AS DATE) AS transaction_date

    ,CAST(svc.TxnNumber AS INT) AS transaction_number
    ,NULLIF(svc.RefNumber, '') AS reference_number

    ,CASE WHEN svc.VendorRef_FullName = '' THEN 'Unassigned' ELSE svc.VendorRef_FullName END AS vendor_full_name
    ,CASE WHEN svc.APAccountRef_FullName = '' THEN 'Unassigned' ELSE svc.APAccountRef_FullName END AS account_full_name

    ,CAST(svc.CreditAmount AS DECIMAL(12, 4)) AS credit_amount
    ,CAST(svc.OpenAmount AS DECIMAL(12, 4)) AS open_amount

    ,NULLIF(svc.EditSequence, '') AS edit_sequence
    ,CAST(svc.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(svc.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(svc.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendor_credit AS svc
-- << INCREMENTAL >> --
WHERE
  CAST(svc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  