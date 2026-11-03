SELECT
    sstpc.TxnID AS sales_tax_payment_check_id
    ,CASE WHEN sstpc.PayeeEntityRef_ListID = '' THEN '0' ELSE sstpc.PayeeEntityRef_ListID END AS vendor_id
    ,CASE WHEN sstpc.BankAccountRef_ListID = '' THEN '0' ELSE sstpc.BankAccountRef_ListID END AS account_id

    ,CAST(sstpc.TxnDate AS DATE) AS transaction_date

    ,CAST(sstpc.TxnNumber AS INT) AS transaction_number
    ,NULLIF(sstpc.RefNumber, '') AS reference_number

    ,NULLIF(sstpc.Memo, '') AS memo

    ,CAST(sstpc.IsToBePrinted AS BOOLEAN) AS is_to_be_printed

    ,NULLIF(sstpc.Address_Addr1, '') AS address_line_1
    ,NULLIF(sstpc.Address_Addr2, '') AS address_line_2
    ,NULLIF(sstpc.Address_City, '') AS city
    ,NULLIF(sstpc.Address_State, '') AS state
    ,NULLIF(sstpc.Address_PostalCode, '') AS postal_code
    ,NULLIF(sstpc.AddressBlock_Addr1, '') AS address_block_1
    ,NULLIF(sstpc.AddressBlock_Addr2, '') AS address_block_2
    ,NULLIF(sstpc.AddressBlock_Addr3, '') AS address_block_3

    ,CASE WHEN sstpc.PayeeEntityRef_FullName = '' THEN 'Unassigned' ELSE sstpc.PayeeEntityRef_FullName END AS vendor_full_name

    ,CAST(sstpc.Amount AS DECIMAL(12,4)) AS total_amount

    ,NULLIF(sstpc.EditSequence, '') AS edit_sequence
    ,CAST(sstpc.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sstpc.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sstpc.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_payment_check AS sstpc
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_sales_tax_payment_check AS tstpc
    ON sstpc.TxnID = tstpc.sales_tax_payment_check_id
WHERE
  (
    tstpc.sales_tax_payment_check_id IS NULL
    OR CAST(sstpc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )