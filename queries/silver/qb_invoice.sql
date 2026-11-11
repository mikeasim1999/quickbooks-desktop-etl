SELECT
    si.TxnID AS invoice_id
    ,CASE WHEN si.CustomerRef_ListID = '' THEN '0' ELSE si.CustomerRef_ListID END AS customer_id
    ,CASE WHEN si.ClassRef_ListID = '' THEN '0' ELSE si.ClassRef_ListID END AS class_id
    ,CASE WHEN si.ARAccountRef_ListID = '' THEN '0' ELSE si.ARAccountRef_ListID END AS account_id
    ,CASE WHEN si.TemplateRef_ListID = '' THEN '0' ELSE si.TemplateRef_ListID END AS template_id
    ,CASE WHEN si.TermsRef_ListID = '' THEN '0' ELSE si.TermsRef_ListID END AS terms_id
    ,CASE WHEN si.CustomerSalesTaxCodeRef_ListID = '' THEN '0' ELSE si.CustomerSalesTaxCodeRef_ListID END AS customer_sales_tax_code_id
    ,CASE WHEN si.ItemSalesTaxRef_ListID = '' THEN '0' ELSE si.ItemSalesTaxRef_ListID END AS item_sales_tax_id

    ,CAST(si.TxnDate AS DATE) AS transaction_date
    ,CAST(si.DueDate AS DATE) AS due_date
    ,CAST(si.ShipDate AS DATE) AS ship_date

    ,CAST(si.TxnNumber AS INT) AS transaction_number
    ,NULLIF(si.RefNumber, '') AS reference_number

    ,CAST(si.IsPaid AS BOOLEAN) AS is_paid
    ,CAST(si.IsPending AS BOOLEAN) AS is_pending
    ,CAST(si.IsFinanceCharge AS BOOLEAN) AS is_finance_charge
    ,CAST(si.IsToBePrinted AS BOOLEAN) AS is_to_be_printed
    ,CAST(si.IsToBeEmailed AS BOOLEAN) AS is_to_be_emailed

    ,CASE WHEN si.CustomerRef_FullName = '' THEN 'Unassigned' ELSE si.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN si.ClassRef_FullName = '' THEN 'Unassigned' ELSE si.ClassRef_FullName END AS class_full_name
    ,CASE WHEN si.ARAccountRef_FullName = '' THEN 'Unassigned' ELSE si.ARAccountRef_FullName END AS account_full_name
    ,CASE WHEN si.TemplateRef_FullName = '' THEN 'Unassigned' ELSE si.TemplateRef_FullName END AS template_full_name
    ,CASE WHEN si.TermsRef_FullName = '' THEN 'Unassigned' ELSE si.TermsRef_FullName END AS terms_full_name
    ,CASE WHEN si.ItemSalesTaxRef_FullName = '' THEN 'Unassigned' ELSE si.ItemSalesTaxRef_FullName END AS item_sales_tax_full_name
    ,CASE WHEN si.CustomerSalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE si.CustomerSalesTaxCodeRef_FullName END AS customer_sales_tax_full_name

    ,NULLIF(si.BillAddress_Addr1, '') AS billing_address_1
    ,NULLIF(si.BillAddress_Addr2, '') AS billing_address_2
    ,NULLIF(si.BillAddress_City, '') AS billing_city
    ,NULLIF(si.BillAddress_State, '') AS billing_state
    ,NULLIF(si.BillAddress_PostalCode, '') AS billing_postal_code
    ,NULLIF(si.BillAddressBlock_Addr1, '') AS billing_address_block_1
    ,NULLIF(si.BillAddressBlock_Addr2, '') AS billing_address_block_2
    ,NULLIF(si.BillAddressBlock_Addr3, '') AS billing_address_block_3

    ,CAST(si.AppliedAmount AS DECIMAL(12,4)) AS applied_amount
    ,CAST(si.SalesTaxPercentage AS DECIMAL(4,2)) / 100 AS sales_tax_percentage
    ,CAST(si.SalesTaxTotal AS DECIMAL(12,4)) AS sales_tax_amount
    ,CAST(si.Subtotal AS DECIMAL(12,4)) AS subtotal_amount
    ,CAST(si.BalanceRemaining AS DECIMAL(12,4)) AS balance_remaining_amount

    ,NULLIF(si.EditSequence, '') AS edit_sequence
    ,CAST(si.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(si.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(si.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_invoice AS si
-- << INCREMENTAL >> --
WHERE
  CAST(si.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  