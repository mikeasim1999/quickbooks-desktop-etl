SELECT
    ssrl.TxnLineID AS sales_receipt_line_id
    ,ssrl.TxnID AS sales_receipt_id
    ,CASE WHEN ssrl.ClassRef_ListID = '' THEN '0' ELSE ssrl.ClassRef_ListID END AS class_id
    ,CASE WHEN ssrl.ItemRef_ListID = '' THEN '0' ELSE ssrl.ItemRef_ListID END AS item_id
    ,CASE WHEN ssrl.SalesTaxCodeRef_ListID = '' THEN '0' ELSE ssrl.SalesTaxCodeRef_ListID END AS sales_tax_code_id

    ,NULLIF(ssrl.Desc, '') AS description

    ,CASE WHEN ssrl.ClassRef_FullName = '' THEN 'Unassigned' ELSE ssrl.ClassRef_FullName END AS class_full_name
    ,CASE WHEN ssrl.ItemRef_FullName = '' THEN 'Unassigned' ELSE ssrl.ItemRef_FullName END AS item_full_name
    ,CASE WHEN ssrl.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE ssrl.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name

    ,CASE WHEN ssrl.Rate = '' THEN 0 ELSE CAST(ssrl.Rate AS DECIMAL(12, 4)) END AS rate
    ,CASE WHEN ssrl.Amount = '' THEN 0 ELSE CAST(ssrl.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN ssrl.Quantity = '' THEN 0 ELSE CAST(ssrl.Quantity AS DECIMAL(12, 4)) END AS quantity

    ,ssrl.ChildTag AS child_tag
    ,CAST(ssrl.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_receipt_lines AS ssrl
-- << INCREMENTAL >> --
WHERE ssrl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_receipt AS sr
    WHERE CAST(sr.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)