SELECT
    sbpc.TxnID AS bill_payment_check_id
    ,CASE WHEN sbpc.PayeeEntityRef_ListID = '' THEN '0' ELSE sbpc.PayeeEntityRef_ListID END AS vendor_id
    ,CASE WHEN sbpc.APAccountRef_ListID = '' THEN '0' ELSE sbpc.APAccountRef_ListID END AS ap_account_id
    ,CASE WHEN sbpc.BankAccountRef_ListID = '' THEN '0' ELSE sbpc.BankAccountRef_ListID END AS bank_account_id
    
    ,CAST(sbpc.TxnDate AS DATE) AS transaction_date 
    
    ,CAST(sbpc.TxnNumber AS INT) AS transaction_number
    ,NULLIF(sbpc.RefNumber, '') AS reference_number

    ,CAST(sbpc.IsToBePrinted AS BOOLEAN) AS is_to_be_printed

    ,NULLIF(sbpc.Memo, '') AS memo

    ,CASE WHEN sbpc.PayeeEntityRef_FullName = '' THEN 'Unassigned' ELSE sbpc.PayeeEntityRef_FullName END AS vendor_full_name
    ,CASE WHEN sbpc.APAccountRef_FullName = '' THEN 'Unassigned' ELSE sbpc.APAccountRef_FullName END AS ap_account_full_name
    ,CASE WHEN sbpc.BankAccountRef_FullName = '' THEN 'Unassigned' ELSE sbpc.BankAccountRef_FullName END AS bank_account_full_name

    ,NULLIF(sbpc.Address_Addr1, '') AS address_line_1
    ,NULLIF(sbpc.Address_Addr2, '') AS address_line_2
    ,NULLIF(sbpc.Address_City, '') AS city
    ,NULLIF(sbpc.Address_State, '') AS state
    ,NULLIF(sbpc.Address_PostalCode, '') AS postal_code
    ,NULLIF(sbpc.AddressBlock_Addr1, '') AS address_block_line_1
    ,NULLIF(sbpc.AddressBlock_Addr2, '') AS address_block_line_2
    ,NULLIF(sbpc.AddressBlock_Addr3, '') AS address_block_line_3
    
    ,CAST(sbpc.Amount AS DECIMAL(12,4)) AS amount

    ,NULLIF(sbpc.EditSequence, '') AS edit_sequence
    ,CAST(sbpc.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sbpc.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sbpc.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check AS sbpc
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_bill_payment_check AS tbpc
    ON sbpc.TxnID = tbpc.bill_payment_check_id
WHERE
  (
    tbpc.bill_payment_check_id IS NULL
    OR CAST(sbpc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )