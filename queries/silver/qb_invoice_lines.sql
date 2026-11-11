SELECT
    sil.TxnLineID AS invoice_line_id
    ,sil.TxnID AS invoice_id
    ,CASE 
        WHEN sil.ClassRef_ListID = '' AND sil.InvoiceLineRet_ClassRef_ListID = '' THEN '0'
        WHEN sil.ClassRef_ListID = '' THEN sil.InvoiceLineRet_ClassRef_ListID
        ELSE sil.ClassRef_ListID 
    END AS class_id
    ,CASE WHEN sil.InvoiceLineRet_ClassRef_ListID = '' THEN '0' ELSE sil.InvoiceLineRet_ClassRef_ListID END AS invoice_line_class_id
    ,CASE 
        WHEN sil.ItemRef_ListID = '' AND sil.InvoiceLineRet_ItemRef_ListID = '' THEN '0'
        WHEN sil.ItemRef_ListID = '' THEN sil.InvoiceLineRet_ItemRef_ListID
        ELSE sil.ItemRef_ListID 
    END AS item_id
    ,CASE WHEN sil.InvoiceLineRet_ItemRef_ListID = '' THEN '0' ELSE sil.InvoiceLineRet_ItemRef_ListID END AS invoice_line_item_id
    ,CASE WHEN sil.ItemGroupRef_ListID = '' THEN '0' ELSE sil.ItemGroupRef_ListID END AS item_group_id
    ,CASE 
        WHEN sil.SalesTaxCodeRef_ListID = '' AND sil.InvoiceLineRet_SalesTaxCodeRef_ListID = '' THEN '0'
        WHEN sil.SalesTaxCodeRef_ListID = '' THEN sil.InvoiceLineRet_SalesTaxCodeRef_ListID
        ELSE sil.SalesTaxCodeRef_ListID 
    END AS sales_tax_code_id
    ,CASE WHEN sil.InvoiceLineRet_SalesTaxCodeRef_ListID = '' THEN '0' ELSE sil.InvoiceLineRet_SalesTaxCodeRef_ListID END AS invoice_line_sales_tax_code_id

    ,CASE
        WHEN sil.ServiceDate ='' AND sil.InvoiceLineRet_ServiceDate <> ''
            THEN TRY_CAST(sil.InvoiceLineRet_ServiceDate AS DATE)
        ELSE TRY_CAST(sil.ServiceDate AS DATE) 
    END AS service_date
    ,TRY_CAST(sil.InvoiceLineRet_ServiceDate AS DATE) AS invoice_line_service_date

    ,CASE WHEN sil.IsPrintItemsInGroup = '' THEN FALSE ELSE CAST(sil.IsPrintItemsInGroup AS BOOLEAN) END AS is_print_items_in_group

    ,NULLIF(sil.Desc, '') AS description
    ,NULLIF(sil.InvoiceLineRet_Desc, '') AS invoice_line_description

    ,CASE 
        WHEN sil.ClassRef_FullName = '' AND sil.InvoiceLineRet_ClassRef_FullName = '' THEN 'Unassigned'
        WHEN sil.ClassRef_FullName = '' THEN sil.InvoiceLineRet_ClassRef_FullName
        ELSE sil.ClassRef_FullName 
    END AS class_full_name
    ,CASE WHEN sil.InvoiceLineRet_ClassRef_FullName = '' THEN 'Unassigned' ELSE sil.InvoiceLineRet_ClassRef_FullName END AS invoice_line_class_full_name
    ,CASE 
        WHEN sil.ItemRef_FullName = '' AND sil.InvoiceLineRet_ItemRef_FullName = '' THEN 'Unassigned'
        WHEN sil.ItemRef_FullName = '' THEN sil.InvoiceLineRet_ItemRef_FullName
        ELSE sil.ItemRef_FullName 
    END AS item_full_name
    ,CASE WHEN sil.InvoiceLineRet_ItemRef_FullName = '' THEN 'Unassigned' ELSE sil.InvoiceLineRet_ItemRef_FullName END AS invoice_line_item_full_name
    ,CASE WHEN sil.ItemGroupRef_FullName = '' THEN 'Unassigned' ELSE sil.ItemGroupRef_FullName END AS item_group_full_name
    ,CASE 
        WHEN sil.SalesTaxCodeRef_FullName = '' AND sil.InvoiceLineRet_SalesTaxCodeRef_FullName = '' THEN 'Unassigned'
        WHEN sil.SalesTaxCodeRef_FullName = '' THEN sil.InvoiceLineRet_SalesTaxCodeRef_FullName
        ELSE sil.SalesTaxCodeRef_FullName 
    END AS sales_tax_code_full_name
    ,CASE WHEN sil.InvoiceLineRet_SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sil.InvoiceLineRet_SalesTaxCodeRef_FullName END AS invoice_line_sales_tax_code_full_name
    ,NULLIF(sil.InvoiceLineRet_TxnLineID, '') AS invoice_line_txn_line_id

    ,CASE 
        WHEN sil.Quantity = '' AND sil.InvoiceLineRet_Quantity = '' THEN 0
        WHEN sil.Quantity = '' THEN CAST(sil.InvoiceLineRet_Quantity AS DECIMAL(12, 4))
        ELSE CAST(sil.Quantity AS DECIMAL(12, 4)) 
    END AS quantity
    ,CASE WHEN sil.InvoiceLineRet_Quantity = '' THEN 0 ELSE CAST(sil.InvoiceLineRet_Quantity AS DECIMAL(12, 4)) END AS invoice_line_quantity
    ,CASE 
        WHEN sil.Rate = '' AND sil.InvoiceLineRet_Rate = '' THEN 0
        WHEN sil.Rate = '' THEN CAST(sil.InvoiceLineRet_Rate AS DECIMAL(12, 4))
        ELSE CAST(sil.Rate AS DECIMAL(12, 4)) 
    END AS rate
    ,CASE WHEN sil.InvoiceLineRet_Rate = '' THEN 0 ELSE CAST(sil.InvoiceLineRet_Rate AS DECIMAL(12, 4)) END AS invoice_line_rate
    ,CASE 
        WHEN sil.RatePercent = '' AND sil.InvoiceLineRet_RatePercent = '' THEN 0
        WHEN sil.RatePercent = '' THEN CAST(sil.InvoiceLineRet_RatePercent AS DECIMAL(12, 4))
        ELSE CAST(sil.RatePercent AS DECIMAL(12, 4)) 
    END AS rate_percent
    ,CASE WHEN sil.InvoiceLineRet_RatePercent = '' THEN 0 ELSE CAST(sil.InvoiceLineRet_RatePercent AS DECIMAL(12, 4)) END AS invoice_line_rate_percent
    ,CASE 
        WHEN sil.Amount = '' AND sil.InvoiceLineRet_Amount = '' THEN 0
        WHEN sil.Amount = '' THEN CAST(sil.InvoiceLineRet_Amount AS DECIMAL(12, 4))
        ELSE CAST(sil.Amount AS DECIMAL(12, 4)) 
    END AS amount
    ,CASE WHEN sil.InvoiceLineRet_Amount = '' THEN 0 ELSE CAST(sil.InvoiceLineRet_Amount AS DECIMAL(12, 4)) END AS invoice_line_amount
    ,CASE WHEN sil.TotalAmount = '' THEN 0 ELSE CAST(sil.TotalAmount AS DECIMAL(12, 4)) END AS total_amount

    ,sil.ChildTag AS child_tag
    ,CAST(sil.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_invoice_lines AS sil
-- << INCREMENTAL >> --
WHERE sil.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_invoice AS i
    WHERE CAST(i.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)