SELECT
    sso.TxnID AS sales_order_id
    ,CASE WHEN sso.CustomerRef_ListID = '' THEN '0' ELSE sso.CustomerRef_ListID END AS customer_id
    ,CASE WHEN sso.TemplateRef_ListID = '' THEN '0' ELSE sso.TemplateRef_ListID END AS template_id
    ,CASE WHEN sso.ItemSalesTaxRef_ListID = '' THEN '0' ELSE sso.ItemSalesTaxRef_ListID END AS item_sales_tax_id
    ,CASE WHEN sso.CustomerSalesTaxCodeRef_ListID = '' THEN '0' ELSE sso.CustomerSalesTaxCodeRef_ListID END AS customer_sales_tax_code_id

    ,CAST(sso.TxnDate AS DATE) AS transaction_date
    ,CAST(sso.DueDate AS DATE) AS due_date
    ,CAST(sso.ShipDate AS DATE) AS ship_date

    ,CAST(sso.TxnNumber AS INT) AS transaction_number
    ,NULLIF(sso.RefNumber, '') AS reference_number

    ,CAST(sso.IsManuallyClosed AS BOOLEAN) AS is_manually_closed
    ,CAST(sso.IsFullyInvoiced AS BOOLEAN) AS is_fully_invoiced
    ,CAST(sso.IsToBePrinted AS BOOLEAN) AS is_to_be_printed
    ,CAST(sso.IsToBeEmailed AS BOOLEAN) AS is_to_be_emailed

    ,NULLIF(sso.BillAddress_Addr1, '') AS bill_address_1
    ,NULLIF(sso.BillAddress_Addr2, '') AS bill_address_2
    ,NULLIF(sso.BillAddress_City, '') AS bill_city
    ,NULLIF(sso.BillAddress_State, '') AS bill_state
    ,NULLIF(sso.BillAddress_PostalCode, '') AS bill_postal_code
    ,NULLIF(sso.BillAddressBlock_Addr1, '') AS bill_address_block_1
    ,NULLIF(sso.BillAddressBlock_Addr2, '') AS bill_address_block_2
    ,NULLIF(sso.BillAddressBlock_Addr3, '') AS bill_address_block_3

    ,NULLIF(sso.ShipAddress_Addr1, '') AS ship_address_1
    ,NULLIF(sso.ShipAddress_Addr2, '') AS ship_address_2
    ,NULLIF(sso.ShipAddress_City, '') AS ship_city
    ,NULLIF(sso.ShipAddress_State, '') AS ship_state
    ,NULLIF(sso.ShipAddress_PostalCode, '') AS ship_postal_code
    ,NULLIF(sso.ShipAddressBlock_Addr1, '') AS ship_address_block_1
    ,NULLIF(sso.ShipAddressBlock_Addr2, '') AS ship_address_block_2
    ,NULLIF(sso.ShipAddressBlock_Addr3, '') AS ship_address_block_3

    ,CASE WHEN sso.CustomerRef_FullName = '' THEN 'Unassigned' ELSE sso.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN sso.TemplateRef_FullName = '' THEN 'Unassigned' ELSE sso.TemplateRef_FullName END AS template_full_name
    ,CASE WHEN sso.ItemSalesTaxRef_FullName = '' THEN 'Unassigned' ELSE sso.ItemSalesTaxRef_FullName END AS item_sales_tax_full_name
    ,CASE WHEN sso.CustomerSalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sso.CustomerSalesTaxCodeRef_FullName END AS customer_sales_tax_full_name

    ,NULLIF(sso.FulfillmentStatus, '') AS fulfillment_status
    
    ,CAST(sso.TotalAmount AS DECIMAL(12,4)) AS total_amount
    ,CAST(sso.SalesTaxPercentage AS DECIMAL(4,2)) AS sales_tax_percentage
    ,CAST(sso.SalesTaxPercentage AS DECIMAL(4,2)) / 100 AS sales_tax_decimal
    ,CAST(sso.SalesTaxTotal AS DECIMAL(12,4)) AS sales_tax_amount
    ,CAST(sso.Subtotal AS DECIMAL(12,4)) AS subtotal_amount

    ,NULLIF(sso.EditSequence, '') AS edit_sequence
    ,CAST(sso.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sso.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sso.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_order AS sso
-- << INCREMENTAL >> --
WHERE
  CAST(sso.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  