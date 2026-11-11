SELECT
    scml.TxnLineID AS credit_memo_line_id
    ,scml.TxnID AS credit_memo_id
    ,CASE WHEN scml.ItemRef_ListID = '' THEN '0' ELSE scml.ItemRef_ListID END AS item_id
    ,CASE WHEN scml.ClassRef_ListID = '' THEN '0' ELSE scml.ClassRef_ListID END AS class_id
    ,CASE WHEN scml.SalesTaxCodeRef_ListID = '' THEN '0' ELSE scml.SalesTaxCodeRef_ListID END AS sales_tax_code_id

    ,NULLIF(scml.Desc, '') AS description

    ,CASE WHEN scml.ItemRef_FullName = '' THEN 'Unassigned' ELSE scml.ItemRef_FullName END AS item_full_name
    ,CASE WHEN scml.ClassRef_FullName = '' THEN 'Unassigned' ELSE scml.ClassRef_FullName END AS class_full_name
    ,CASE WHEN scml.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE scml.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name

    ,CASE WHEN scml.Rate = '' THEN 0 ELSE CAST(scml.Rate AS DECIMAL(12, 4)) END AS rate
    ,CASE WHEN scml.Amount = '' THEN 0 ELSE CAST(scml.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN scml.Quantity = '' THEN 0 ELSE CAST(scml.Quantity AS DECIMAL(12, 4)) END AS quantity

    ,scml.ChildTag AS child_tag
    ,CAST(scml.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_memo_lines AS scml
-- << INCREMENTAL >> --
WHERE scml.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_memo AS cm
    WHERE CAST(cm.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)