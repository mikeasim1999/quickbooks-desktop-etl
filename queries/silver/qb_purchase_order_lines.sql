SELECT
    spol.TxnLineID AS purchase_order_line_id
    ,spol.TxnID AS purchase_order_id
    ,CASE WHEN spol.ClassRef_ListID = '' THEN '0' ELSE spol.ClassRef_ListID END AS class_id
    ,CASE WHEN spol.CustomerRef_ListID = '' THEN '0' ELSE spol.CustomerRef_ListID END AS customer_id
    ,CASE WHEN spol.ItemRef_ListID = '' THEN '0' ELSE spol.ItemRef_ListID END AS item_id

    ,CAST(spol.IsBilled AS BOOLEAN) AS is_billed
    ,CAST(spol.IsManuallyClosed AS BOOLEAN) AS is_manually_closed

    ,NULLIF(spol.Desc, '') AS description

    ,CASE WHEN spol.ClassRef_FullName = '' THEN 'Unassigned' ELSE spol.ClassRef_FullName END AS class_full_name
    ,CASE WHEN spol.CustomerRef_FullName = '' THEN 'Unassigned' ELSE spol.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN spol.ItemRef_FullName = '' THEN 'Unassigned' ELSE spol.ItemRef_FullName END AS item_full_name

    ,CASE WHEN spol.Rate = '' THEN 0 ELSE CAST(spol.Rate AS DECIMAL(12, 4)) END AS rate
    ,CASE WHEN spol.Amount = '' THEN 0 ELSE CAST(spol.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN spol.Quantity = '' THEN 0 ELSE CAST(spol.Quantity AS DECIMAL(12, 4)) END AS ordered_quantity
    ,CASE WHEN spol.ReceivedQuantity = '' THEN 0 ELSE CAST(spol.ReceivedQuantity AS DECIMAL(12, 4)) END AS received_quantity

    ,spol.ChildTag AS child_tag
    ,CAST(spol.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_purchase_order_lines AS spol
-- << INCREMENTAL >> --
WHERE spol.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_purchase_order AS po
    WHERE CAST(po.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)