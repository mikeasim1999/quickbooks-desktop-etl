SELECT
    sel.TxnLineID AS estimate_line_id
    ,sel.TxnID AS estimate_id
    ,CASE 
        WHEN sel.ClassRef_ListID = '' AND sel.EstimateLineRet_ClassRef_ListID = '' THEN '0'
        WHEN sel.ClassRef_ListID = '' THEN sel.EstimateLineRet_ClassRef_ListID
        ELSE sel.ClassRef_ListID 
    END AS class_id
    ,CASE WHEN sel.EstimateLineRet_ClassRef_ListID = '' THEN '0' ELSE sel.EstimateLineRet_ClassRef_ListID END AS estimate_line_class_id
    ,CASE 
        WHEN sel.ItemRef_ListID = '' AND sel.EstimateLineRet_ItemRef_ListID = '' THEN '0'
        WHEN sel.ItemRef_ListID = '' THEN sel.EstimateLineRet_ItemRef_ListID
        ELSE sel.ItemRef_ListID 
    END AS item_id
    ,CASE WHEN sel.EstimateLineRet_ItemRef_ListID = '' THEN '0' ELSE sel.EstimateLineRet_ItemRef_ListID END AS estimate_line_item_id
    ,CASE WHEN sel.ItemGroupRef_ListID = '' THEN '0' ELSE sel.ItemGroupRef_ListID END AS item_group_id
    ,CASE 
        WHEN sel.SalesTaxCodeRef_ListID = '' AND sel.EstimateLineRet_SalesTaxCodeRef_ListID = '' THEN '0'
        WHEN sel.SalesTaxCodeRef_ListID = '' THEN sel.EstimateLineRet_SalesTaxCodeRef_ListID
        ELSE sel.SalesTaxCodeRef_ListID
    END AS sales_tax_id
    ,CASE WHEN sel.EstimateLineRet_SalesTaxCodeRef_ListID = '' THEN '0' ELSE sel.EstimateLineRet_SalesTaxCodeRef_ListID END AS estimate_line_sales_tax_id

    ,NULLIF(sel.Desc, '') AS description
    ,NULLIF(sel.EstimateLineRet_Desc, '') AS estimate_line_description

    ,CASE WHEN sel.IsPrintItemsInGroup = '' THEN FALSE ELSE CAST(sel.IsPrintItemsInGroup AS BOOLEAN) END AS is_print_items_in_group

    ,CASE 
        WHEN sel.ClassRef_FullName = '' AND sel.EstimateLineRet_ClassRef_FullName = '' THEN 'Unassigned'
        WHEN sel.ClassRef_FullName = '' THEN sel.EstimateLineRet_ClassRef_FullName
        ELSE sel.ClassRef_FullName 
    END AS class_full_name
    ,CASE WHEN sel.EstimateLineRet_ClassRef_FullName = '' THEN 'Unassigned' ELSE sel.EstimateLineRet_ClassRef_FullName END AS estimate_line_class_full_name
    ,CASE 
        WHEN sel.ItemRef_FullName = '' AND sel.EstimateLineRet_ItemRef_FullName = '' THEN 'Unassigned'
        WHEN sel.ItemRef_FullName = '' THEN sel.EstimateLineRet_ItemRef_FullName
        ELSE sel.ItemRef_FullName 
    END AS item_full_name
    ,CASE WHEN sel.EstimateLineRet_ItemRef_FullName = '' THEN 'Unassigned' ELSE sel.EstimateLineRet_ItemRef_FullName END AS estimate_line_item_full_name
    ,CASE 
        WHEN sel.SalesTaxCodeRef_FullName = '' AND sel.EstimateLineRet_SalesTaxCodeRef_FullName = '' THEN 'Unassigned'
        WHEN sel.SalesTaxCodeRef_FullName = '' THEN sel.EstimateLineRet_SalesTaxCodeRef_FullName
        ELSE sel.SalesTaxCodeRef_FullName
    END AS sales_tax_full_name
    ,CASE WHEN sel.EstimateLineRet_SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sel.EstimateLineRet_SalesTaxCodeRef_FullName END AS estimate_line_sales_tax_full_name
    ,CASE WHEN sel.ItemGroupRef_FullName = '' THEN 'Unassigned' ELSE sel.ItemGroupRef_FullName END AS item_group_full_name

    ,NULLIF(sel.EstimateLineRet_TxnLineID, '') AS estimate_line_txn_line_id

        ,CASE 
        WHEN sel.Rate = '' AND sel.EstimateLineRet_Rate = '' THEN 0
        WHEN sel.Rate = '' THEN CAST(sel.EstimateLineRet_Rate AS DECIMAL(12, 4))
        ELSE CAST(sel.Rate AS DECIMAL(12, 4)) 
    END AS rate
    ,CASE WHEN sel.EstimateLineRet_Rate = '' THEN 0 ELSE CAST(sel.EstimateLineRet_Rate AS DECIMAL(12, 4)) END AS estimate_line_rate
    ,CASE 
        WHEN sel.Amount = '' AND sel.EstimateLineRet_Amount = '' THEN 0
        WHEN sel.Amount = '' THEN CAST(sel.EstimateLineRet_Amount AS DECIMAL(12, 4))
        ELSE CAST(sel.Amount AS DECIMAL(12, 4)) 
    END AS amount
    ,CASE WHEN sel.EstimateLineRet_Amount = '' THEN 0 ELSE CAST(sel.EstimateLineRet_Amount AS DECIMAL(12, 4)) END AS estimate_line_amount
    ,CASE 
        WHEN sel.MarkupRatePercent = '' AND sel.EstimateLineRet_MarkupRatePercent = '' THEN 0
        WHEN sel.MarkupRatePercent = '' THEN CAST(sel.EstimateLineRet_MarkupRatePercent AS DECIMAL(12, 4))
        ELSE CAST(sel.MarkupRatePercent AS DECIMAL(12, 4)) 
    END AS markup_percentage
    ,CASE WHEN sel.EstimateLineRet_MarkupRatePercent = '' THEN 0 ELSE CAST(sel.EstimateLineRet_MarkupRatePercent AS DECIMAL(12, 4)) END AS estimate_line_markup_percentage
    ,CASE 
        WHEN sel.Quantity = '' AND sel.EstimateLineRet_Quantity = '' THEN 0
        WHEN sel.Quantity = '' THEN CAST(sel.EstimateLineRet_Quantity AS DECIMAL(12, 4))
        ELSE CAST(sel.Quantity AS DECIMAL(12, 4)) 
    END AS quantity
    ,CASE WHEN sel.EstimateLineRet_Quantity = '' THEN 0 ELSE CAST(sel.EstimateLineRet_Quantity AS DECIMAL(12, 4)) END AS estimate_line_quantity
    ,CASE WHEN sel.TotalAmount = '' THEN 0 ELSE CAST(sel.TotalAmount AS DECIMAL(12, 4)) END AS total_amount

    ,sel.ChildTag AS child_tag
    ,CAST(sel.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_estimate_lines AS sel
-- << INCREMENTAL >> --
WHERE sel.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_estimate AS e
    WHERE CAST(e.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)