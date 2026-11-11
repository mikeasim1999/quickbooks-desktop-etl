SELECT
    ssr.TxnID AS sales_receipt_id
    ,CASE WHEN ssr.DepositToAccountRef_ListID = '' THEN '0' ELSE ssr.DepositToAccountRef_ListID END AS account_id
    ,CASE WHEN ssr.CustomerRef_ListID = '' THEN '0' ELSE ssr.CustomerRef_ListID END AS customer_id
    ,CASE WHEN ssr.ClassRef_ListID = '' THEN '0' ELSE ssr.ClassRef_ListID END AS class_id
    ,CASE WHEN ssr.TemplateRef_ListID = '' THEN '0' ELSE ssr.TemplateRef_ListID END AS template_id
    ,CASE WHEN ssr.PaymentMethodRef_ListID = '' THEN '0' ELSE ssr.PaymentMethodRef_ListID END AS payment_method_id
    ,CASE WHEN ssr.ItemSalesTaxRef_ListID = '' THEN '0' ELSE ssr.ItemSalesTaxRef_ListID END AS item_sales_tax_id
    ,CASE WHEN ssr.CustomerSalesTaxCodeRef_ListID = '' THEN '0' ELSE ssr.CustomerSalesTaxCodeRef_ListID END AS customer_sales_tax_code_id
    ,CASE WHEN ssr.CustomerMsgRef_ListID = '' THEN '0' ELSE ssr.CustomerMsgRef_ListID END AS customer_message_id

    ,CAST(ssr.TxnDate AS DATE) AS transaction_date
    ,CAST(ssr.DueDate AS DATE) AS due_date
    ,CAST(ssr.ShipDate AS DATE) AS ship_date

    ,CAST(ssr.TxnNumber AS INT) AS transaction_number
    ,NULLIF(ssr.RefNumber, '') AS reference_number
    ,NULLIF(ssr.CheckNumber, '') AS check_number

    ,CAST(ssr.IsPending AS BOOLEAN) AS is_pending
    ,CAST(ssr.IsToBePrinted AS BOOLEAN) AS is_to_be_printed
    ,CAST(ssr.IsToBeEmailed AS BOOLEAN) AS is_to_be_emailed

    ,NULLIF(ssr.BillAddress_Addr1, '') AS bill_address_1
    ,NULLIF(ssr.BillAddress_Addr2, '') AS bill_address_2
    ,NULLIF(ssr.BillAddress_City, '') AS bill_address_city
    ,NULLIF(ssr.BillAddress_State, '') AS bill_address_state
    ,NULLIF(ssr.BillAddress_PostalCode, '') AS bill_address_postal_code
    ,NULLIF(ssr.BillAddressBlock_Addr1, '') AS bill_address_block_1
    ,NULLIF(ssr.BillAddressBlock_Addr2, '') AS bill_address_block_2
    ,NULLIF(ssr.BillAddressBlock_Addr3, '') AS bill_address_block_3

    ,CASE WHEN ssr.CustomerRef_FullName = '' THEN 'Unassigned' ELSE ssr.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN ssr.CustomerMsgRef_FullName = '' THEN 'Unassigned' ELSE ssr.CustomerMsgRef_FullName END AS customer_message_full_name
    ,CASE WHEN ssr.ClassRef_FullName = '' THEN 'Unassigned' ELSE ssr.ClassRef_FullName END AS class_full_name
    ,CASE WHEN ssr.DepositToAccountRef_FullName = '' THEN 'Unassigned' ELSE ssr.DepositToAccountRef_FullName END AS account_full_name
    ,CASE WHEN ssr.TemplateRef_FullName = '' THEN 'Unassigned' ELSE ssr.TemplateRef_FullName END AS template_full_name
    ,CASE WHEN ssr.PaymentMethodRef_FullName = '' THEN 'Unassigned' ELSE ssr.PaymentMethodRef_FullName END AS payment_method_full_name
    ,CASE WHEN ssr.ItemSalesTaxRef_FullName = '' THEN 'Unassigned' ELSE ssr.ItemSalesTaxRef_FullName END AS item_sales_tax_full_name
    ,CASE WHEN ssr.CustomerSalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE ssr.CustomerSalesTaxCodeRef_FullName END AS customer_sales_tax_full_name

    ,CAST(ssr.TotalAmount AS DECIMAL(12,4)) AS total_amount
    ,CAST(ssr.SalesTaxPercentage AS DECIMAL(4,2)) AS sales_tax_percentage
    ,CAST(ssr.SalesTaxPercentage AS DECIMAL(4,2)) / 100 AS sales_tax_decimal
    ,CAST(ssr.SalesTaxTotal AS DECIMAL(12,4)) AS sales_tax_amount
    ,CAST(ssr.Subtotal AS DECIMAL(12,4)) AS subtotal_amount

    ,NULLIF(ssr.EditSequence, '') AS edit_sequence
    ,CAST(ssr.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(ssr.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(ssr.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_receipt AS ssr
-- << INCREMENTAL >> --
WHERE
  CAST(ssr.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'