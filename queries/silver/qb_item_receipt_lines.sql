SELECT
    irl.TxnLineID AS item_receipt_line_id
    ,irl.TxnID AS item_receipt_id
    ,CASE WHEN irl.ItemRef_ListID = '' THEN '0' ELSE irl.ItemRef_ListID END AS item_id
    ,CASE WHEN irl.ClassRef_ListID = '' THEN '0' ELSE irl.ClassRef_ListID END AS class_id
    ,CASE WHEN irl.CustomerRef_ListID = '' THEN '0' ELSE irl.CustomerRef_ListID END AS customer_id

    ,TRIM(REGEXP_REPLACE(irl.BillableStatus, '([A-Z])', ' $1')) AS billable_status

    ,NULLIF(irl.Desc, '') AS description

    ,CASE WHEN irl.ItemRef_FullName = '' THEN 'Unassigned' ELSE irl.ItemRef_FullName END AS item_full_name
    ,CASE WHEN irl.ClassRef_FullName = '' THEN 'Unassigned' ELSE irl.ClassRef_FullName END AS class_full_name
    ,CASE WHEN irl.CustomerRef_FullName = '' THEN 'Unassigned' ELSE irl.CustomerRef_FullName END AS customer_full_name

    ,CASE WHEN irl.Cost = '' THEN 0 ELSE CAST(irl.Cost AS DECIMAL(12, 4)) END AS cost
    ,CASE WHEN irl.Amount = '' THEN 0 ELSE CAST(irl.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN irl.Quantity = '' THEN 0 ELSE CAST(irl.Quantity AS DECIMAL(12, 4)) END AS quantity

    ,irl.ChildTag AS child_tag
    ,CAST(irl.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_receipt_lines AS irl
-- << INCREMENTAL >> --
WHERE irl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_receipt AS ir
    WHERE CAST(ir.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)