SELECT
    sb.TxnID AS bill_id
    ,CASE WHEN sb.VendorRef_ListID = '' THEN '0' ELSE sb.VendorRef_ListID END AS vendor_id
    ,CASE WHEN sb.APAccountRef_ListID = '' THEN '0' ELSE sb.APAccountRef_ListID END AS account_id
    ,CASE WHEN sb.TermsRef_ListID = '' THEN '0' ELSE sb.TermsRef_ListID END AS terms_id

    ,CAST(sb.TxnDate AS DATE) AS transaction_date
    ,CAST(sb.DueDate AS DATE) AS due_date
    
    ,CAST(sb.TxnNumber AS INT) AS transaction_number
    ,NULLIF(sb.RefNumber, '') AS reference_number

    ,CAST(sb.IsPending AS BOOLEAN) AS is_pending
    ,CAST(sb.IsPaid AS BOOLEAN) AS is_paid
    
    ,CASE WHEN sb.VendorRef_FullName = '' THEN 'Unassigned' ELSE sb.VendorRef_FullName END AS vendor_full_name
    ,NULLIF(sb.VendorAddress_Addr1, '') AS vendor_address_1
    ,NULLIF(sb.VendorAddress_Addr2, '') AS vendor_address_2
    ,NULLIF(sb.VendorAddress_City, '') AS vendor_city
    ,NULLIF(sb.VendorAddress_State, '') AS vendor_state
    ,NULLIF(sb.VendorAddress_PostalCode, '') AS vendor_postal_code

    ,CASE WHEN sb.APAccountRef_FullName = '' THEN 'Unassigned' ELSE sb.APAccountRef_FullName END AS account_name
    ,CASE WHEN sb.TermsRef_FullName = '' THEN 'Unassigned' ELSE sb.TermsRef_FullName END AS terms_name

    ,TRY_CAST(sb.OpenAmount AS DECIMAL(12, 4)) AS amount_open
    ,TRY_CAST(sb.AmountDue AS DECIMAL(12, 4)) AS amount_due

    ,NULLIF(sb.EditSequence, '') AS edit_sequence
    ,CAST(sb.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sb.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sb.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill AS sb
-- << INCREMENTAL >> --
WHERE
    CAST(sb.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  