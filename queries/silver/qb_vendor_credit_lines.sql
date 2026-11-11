SELECT
    svcl.TxnLineID AS vendor_credit_line_id
    ,svcl.TxnID AS vendor_credit_id
    ,CASE WHEN svcl.ClassRef_ListID = '' THEN '0' ELSE svcl.ClassRef_ListID END AS class_id
    ,CASE WHEN svcl.ItemRef_ListID = '' THEN '0' ELSE svcl.ItemRef_ListID END AS item_id
    ,CASE WHEN svcl.CustomerRef_ListID = '' THEN '0' ELSE svcl.CustomerRef_ListID END AS customer_id

    ,TRIM(REGEXP_REPLACE(svcl.BillableStatus, '([A-Z])', ' $1')) AS billable_status

    ,NULLIF(svcl.Desc, '') AS description

    ,CASE WHEN svcl.ClassRef_FullName = '' THEN 'Unassigned' ELSE svcl.ClassRef_FullName END AS class_full_name
    ,CASE WHEN svcl.ItemRef_FullName = '' THEN 'Unassigned' ELSE svcl.ItemRef_FullName END AS item_full_name
    ,CASE WHEN svcl.CustomerRef_FullName = '' THEN 'Unassigned' ELSE svcl.CustomerRef_FullName END AS customer_full_name

    ,CASE WHEN svcl.Cost = '' THEN 0 ELSE CAST(svcl.Cost AS DECIMAL(12, 4)) END AS cost
    ,CASE WHEN svcl.Amount = '' THEN 0 ELSE CAST(svcl.Amount AS DECIMAL(12, 4)) END AS amount

    ,svcl.ChildTag AS child_tag
    ,CAST(svcl.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendor_credit_lines AS svcl
-- << INCREMENTAL >> --
WHERE svcl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendor_credit AS vc
    WHERE CAST(vc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)