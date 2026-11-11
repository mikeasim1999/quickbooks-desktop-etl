SELECT
    sbl.TxnLineID AS bill_line_id
    ,sbl.TxnID AS bill_id
    ,CASE WHEN sbl.AccountRef_ListID = '' THEN '0' ELSE sbl.AccountRef_ListID END AS account_id
    ,CASE WHEN sbl.ClassRef_ListID = '' THEN '0' ELSE sbl.ClassRef_ListID END AS class_id
    ,CASE WHEN sbl.CustomerRef_ListID = '' THEN '0' ELSE sbl.CustomerRef_ListID END AS customer_id
    ,CASE WHEN sbl.ItemRef_ListID = '' THEN '0' ELSE sbl.ItemRef_ListID END AS item_id

    ,TRIM(REGEXP_REPLACE(sbl.BillableStatus, '([A-Z])', ' $1')) AS billable_status

    ,NULLIF(sbl.Memo, '') AS memo
    ,NULLIF(sbl.Desc, '') AS Description

    ,CASE WHEN sbl.AccountRef_FullName = '' THEN 'Unassigned' ELSE sbl.AccountRef_FullName END AS account_full_name
    ,CASE WHEN sbl.ClassRef_FullName = '' THEN 'Unassigned' ELSE sbl.ClassRef_FullName END AS class_full_name
    ,CASE WHEN sbl.CustomerRef_FullName = '' THEN 'Unassigned' ELSE sbl.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN sbl.ItemRef_FullName = '' THEN 'Unassigned' ELSE sbl.ItemRef_FullName END AS item_full_name

    ,CASE WHEN sbl.Cost = '' THEN 0 ELSE CAST(sbl.Cost AS DECIMAL(12,4)) END AS cost
    ,CASE WHEN sbl.Amount = '' THEN 0 ELSE CAST(sbl.Amount AS DECIMAL(12,4)) END AS amount
    ,CASE WHEN sbl.Quantity = '' THEN 0 ELSE CAST(sbl.Quantity AS DECIMAL(12,4)) END AS quantity

    ,sbl.ChildTag AS xml_child_tag
    ,sbl.loaddatetime AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_lines AS sbl
-- << INCREMENTAL >> --
WHERE sbl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill AS b
    WHERE CAST(b.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)