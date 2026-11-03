SELECT
    sc.TxnID AS check_id
    ,CASE WHEN sc.AccountRef_ListID = '' THEN '0' ELSE sc.AccountRef_ListID END AS account_id
    ,CASE WHEN sc.PayeeEntityRef_ListID = '' THEN '0' ELSE sc.PayeeEntityRef_ListID END AS vendor_id

    ,CAST(sc.TxnDate AS DATE) AS transaction_date
    
    ,CAST(sc.TxnNumber AS INT) AS transaction_number
    ,NULLIF(sc.RefNumber, '') AS reference_number

    ,CAST(sc.IsPending AS BOOLEAN) AS is_pending
    ,CAST(sc.IsToBePrinted AS BOOLEAN) AS is_to_be_printed

    ,CASE WHEN sc.AccountRef_FullName = '' THEN 'Unassigned' ELSE sc.AccountRef_FullName END AS account_full_name
    ,CASE WHEN sc.PayeeEntityRef_FullName = '' THEN 'Unassigned' ELSE sc.PayeeEntityRef_FullName END AS vendor_full_name

    ,NULLIF(sc.Address_Addr1, '') AS address_line_1
    ,NULLIF(sc.Address_Addr2, '') AS address_line_2
    ,NULLIF(sc.Address_City, '') AS city
    ,NULLIF(sc.Address_State, '') AS state
    ,NULLIF(sc.Address_PostalCode, '') AS postal_code
    ,NULLIF(sc.AddressBlock_Addr1, '') AS address_block_line_1
    ,NULLIF(sc.AddressBlock_Addr2, '') AS address_block_line_2
    ,NULLIF(sc.AddressBlock_Addr3, '') AS address_block_line_3

    ,CAST(sc.Amount AS DECIMAL(12,4)) AS amount

    ,NULLIF(sc.EditSequence, '') AS edit_sequence
    ,CAST(sc.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sc.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sc.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_check AS sc
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_check AS tc
    ON sc.TxnID = tc.check_id
WHERE
  (
    tc.check_id IS NULL
    OR CAST(sc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )