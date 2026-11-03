SELECT
    scm.TxnID AS credit_memo_id
    ,CASE WHEN scm.CustomerRef_ListID = '' THEN '0' ELSE scm.CustomerRef_ListID END AS customer_id
    ,CASE WHEN scm.ClassRef_ListID = '' THEN '0' ELSE scm.ClassRef_ListID END AS class_id
    ,CASE WHEN scm.ARAccountRef_ListID = '' THEN '0' ELSE scm.ARAccountRef_ListID END AS account_id
    ,CASE WHEN scm.TemplateRef_ListID = '' THEN '0' ELSE scm.TemplateRef_ListID END AS template_id
    ,CASE WHEN scm.ItemSalesTaxRef_ListID = '' THEN '0' ELSE scm.ItemSalesTaxRef_ListID END AS item_sales_tax_id
    ,CASE WHEN scm.CustomerSalesTaxCodeRef_ListID = '' THEN '0' ELSE scm.CustomerSalesTaxCodeRef_ListID END AS customer_sales_tax_code_id
    
    ,CAST(scm.TxnDate AS DATE) AS transaction_date
    ,CAST(scm.DueDate AS DATE) AS due_date
    ,CAST(scm.ShipDate AS DATE) AS ship_date

    ,CAST(scm.TxnNumber AS INT) AS transaction_number
    ,NULLIF(scm.RefNumber, '') AS reference_number

    ,CAST(scm.IsPending AS BOOLEAN) AS is_pending
    ,CAST(scm.IsToBePrinted AS BOOLEAN) AS is_to_be_printed
    ,CAST(scm.IsToBeEmailed AS BOOLEAN) AS is_to_be_emailed

    ,CASE WHEN scm.CustomerRef_FullName = '' THEN 'Unassigned' ELSE scm.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN scm.ClassRef_FullName = '' THEN 'Unassigned' ELSE scm.ClassRef_FullName END AS class_full_name
    ,CASE WHEN scm.ARAccountRef_FullName = '' THEN 'Unassigned' ELSE scm.ARAccountRef_FullName END AS account_full_name
    ,CASE WHEN scm.TemplateRef_FullName = '' THEN 'Unassigned' ELSE scm.TemplateRef_FullName END AS template_full_name
    ,CASE WHEN scm.ItemSalesTaxRef_FullName = '' THEN 'Unassigned' ELSE scm.ItemSalesTaxRef_FullName END AS item_sales_tax_full_name
    ,CASE WHEN scm.CustomerSalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE scm.CustomerSalesTaxCodeRef_FullName END AS customer_sales_tax_code_full_name

    ,NULLIF(scm.BillAddress_Addr1, '') AS billing_address_1
    ,NULLIF(scm.BillAddress_Addr2, '') AS billing_address_2
    ,NULLIF(scm.BillAddress_City, '') AS billing_city
    ,NULLIF(scm.BillAddress_State, '') AS billing_state
    ,NULLIF(scm.BillAddress_PostalCode, '') AS billing_postal_code
    ,NULLIF(scm.BillAddressBlock_Addr1, '') AS billing_address_block_1
    ,NULLIF(scm.BillAddressBlock_Addr2, '') AS billing_address_block_2
    ,NULLIF(scm.BillAddressBlock_Addr3, '') AS billing_address_block_3

    ,CAST(scm.TotalAmount AS DECIMAL(12,4)) AS total_amount
    ,CAST(scm.SalesTaxPercentage AS DECIMAL(4,2)) / 100 AS sales_tax_percentage
    ,CAST(scm.SalesTaxTotal AS DECIMAL(12,4)) AS sales_tax_amount
    ,CAST(scm.Subtotal AS DECIMAL(12,4)) AS subtotal_amount
    ,CAST(scm.CreditRemaining AS DECIMAL(12,4)) AS credit_remaining_amount

    ,NULLIF(scm.EditSequence, '') AS edit_sequence
    ,CAST(scm.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(scm.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(scm.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_memo AS scm
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_credit_memo AS tcm
    ON scm.TxnID = tcm.credit_memo_id
WHERE
  (
    tcm.credit_memo_id IS NULL
    OR CAST(scm.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )