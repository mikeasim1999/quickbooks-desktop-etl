SELECT
    se.TxnID AS estimate_id
    ,CASE WHEN se.CustomerRef_ListID = '' THEN '0' ELSE se.CustomerRef_ListID END AS customer_id
    ,CASE WHEN se.ClassRef_ListID = '' THEN '0' ELSE se.ClassRef_ListID END AS class_id
    ,CASE WHEN se.TemplateRef_ListID = '' THEN '0' ELSE se.TemplateRef_ListID END AS template_id
    ,CASE WHEN se.ItemSalesTaxRef_ListID = '' THEN '0' ELSE se.ItemSalesTaxRef_ListID END AS item_sales_tax_id
    ,CASE WHEN se.CustomerSalesTaxCodeRef_ListID = '' THEN '0' ELSE se.CustomerSalesTaxCodeRef_ListID END AS customer_sales_tax_code_id
    ,CASE WHEN se.CustomerMsgRef_ListID = '' THEN '0' ELSE se.CustomerMsgRef_ListID END AS customer_message_id

    ,CAST(se.TxnDate AS DATE) AS transaction_date
    ,CAST(se.DueDate AS DATE) AS due_date

    ,CAST(se.TxnNumber AS INT) AS transaction_number
    ,NULLIF(se.RefNumber, '') AS reference_number

    ,CAST(se.IsToBeEmailed AS BOOLEAN) AS is_to_be_emailed
    ,CAST(se.IsActive AS BOOLEAN) AS is_active

    ,NULLIF(se.Memo, '') AS memo

    ,CASE WHEN se.CustomerRef_FullName = '' THEN 'Unassigned' ELSE se.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN se.ClassRef_FullName = '' THEN 'Unassigned' ELSE se.ClassRef_FullName END AS class_full_name
    ,CASE WHEN se.TemplateRef_FullName = '' THEN 'Unassigned' ELSE se.TemplateRef_FullName END AS template_full_name
    ,CASE WHEN se.ItemSalesTaxRef_FullName = '' THEN 'Unassigned' ELSE se.ItemSalesTaxRef_FullName END AS item_sales_tax_full_name
    ,CASE WHEN se.CustomerSalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE se.CustomerSalesTaxCodeRef_FullName END AS customer_sales_tax_code_full_name
    ,CASE WHEN se.CustomerMsgRef_FullName = '' THEN 'Unassigned' ELSE se.CustomerMsgRef_FullName END AS customer_message_full_name

    ,NULLIF(se.BillAddress_Addr1, '') AS billing_address_1
    ,NULLIF(se.BillAddress_Addr2, '') AS billing_address_2
    ,NULLIF(se.BillAddress_City, '') AS billing_city
    ,NULLIF(se.BillAddress_State, '') AS billing_state
    ,NULLIF(se.BillAddress_PostalCode, '') AS billing_postal_code
    ,NULLIF(se.BillAddressBlock_Addr1, '') AS billing_address_block_1
    ,NULLIF(se.BillAddressBlock_Addr2, '') AS billing_address_block_2
    ,NULLIF(se.BillAddressBlock_Addr3, '') AS billing_address_block_3

    ,NULLIF(se.ShipAddress_Addr1, '') AS shipping_address_1
    ,NULLIF(se.ShipAddress_Addr2, '') AS shipping_address_2
    ,NULLIF(se.ShipAddress_City, '') AS shipping_city
    ,NULLIF(se.ShipAddress_State, '') AS shipping_state
    ,NULLIF(se.ShipAddress_PostalCode, '') AS shipping_postal_code
    ,NULLIF(se.ShipAddressBlock_Addr1, '') AS shipping_address_block_1
    ,NULLIF(se.ShipAddressBlock_Addr2, '') AS shipping_address_block_2
    ,NULLIF(se.ShipAddressBlock_Addr3, '') AS shipping_address_block_3

    ,CAST(se.TotalAmount AS DECIMAL(12,4)) AS total_amount
    ,CAST(se.SalesTaxPercentage AS DECIMAL(4,2)) / 100 AS sales_tax_percentage
    ,CAST(se.SalesTaxTotal AS DECIMAL(12,4)) AS sales_tax_amount
    ,CAST(se.Subtotal AS DECIMAL(12,4)) AS subtotal_amount

    ,se.EditSequence AS edit_sequence
    ,CAST(se.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(se.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(se.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_estimate AS se
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_estimate AS te
    ON se.TxnID = te.estimate_id
WHERE
  (
    te.estimate_id IS NULL
    OR CAST(se.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  )