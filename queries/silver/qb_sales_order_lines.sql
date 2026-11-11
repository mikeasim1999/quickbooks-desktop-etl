SELECT
    ssol.TxnLineID AS sales_order_line_id
    ,ssol.TxnID AS sales_order_id
    ,CASE WHEN ssol.ClassRef_ListID = '' THEN '0' ELSE ssol.ClassRef_ListID END AS class_id
    ,CASE WHEN ssol.ItemRef_ListID = '' THEN '0' ELSE ssol.ItemRef_ListID END AS item_id
    ,CASE WHEN ssol.SalesTaxCodeRef_ListID = '' THEN '0' ELSE ssol.SalesTaxCodeRef_ListID END AS sales_tax_code_id

    ,CAST(ssol.IsManuallyClosed AS BOOLEAN) AS is_manually_closed

    ,NULLIF(ssol.Desc, '') AS description

    ,CASE WHEN ssol.ClassRef_FullName = '' THEN 'Unassigned' ELSE ssol.ClassRef_FullName END AS class_full_name
    ,CASE WHEN ssol.ItemRef_FullName = '' THEN 'Unassigned' ELSE ssol.ItemRef_FullName END AS item_full_name
    ,CASE WHEN ssol.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE ssol.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name

    ,CASE WHEN ssol.Rate = '' THEN 0 ELSE CAST(ssol.Rate AS DECIMAL(12, 4)) END AS rate
    ,CASE WHEN ssol.Amount = '' THEN 0 ELSE CAST(ssol.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN ssol.Quantity = '' THEN 0 ELSE CAST(ssol.Quantity AS DECIMAL(12, 4)) END AS ordered_quantity
    ,CASE WHEN ssol.Invoiced = '' THEN 0 ELSE CAST(ssol.Invoiced AS DECIMAL(12, 4)) END AS invoiced_quantity

    ,ssol.ChildTag AS child_tag
    ,CAST(ssol.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_order_lines AS ssol
-- << INCREMENTAL >> --
WHERE ssol.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_order AS so
    WHERE CAST(so.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)