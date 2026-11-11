SELECT
    scl.TxnLineID AS check_line_id
    ,scl.TxnID AS check_id
    ,CASE WHEN scl.OverrideUOMSetRef_ListID = '' THEN '0' ELSE scl.OverrideUOMSetRef_ListID END AS override_uom_set_id
    ,CASE WHEN scl.AccountRef_ListID = '' THEN '0' ELSE scl.AccountRef_ListID END AS account_id
    ,CASE WHEN scl.CustomerRef_ListID = '' THEN '0' ELSE scl.CustomerRef_ListID END AS customer_id
    ,CASE WHEN scl.ItemRef_ListID = '' THEN '0' ELSE scl.ItemRef_ListID END AS item_id
    ,CASE WHEN scl.ClassRef_ListID = '' THEN '0' ELSE scl.ClassRef_ListID END AS class_id

    ,TRIM(REGEXP_REPLACE(scl.BillableStatus, '([A-Z])', ' $1')) AS billable_status

    ,NULLIF(scl.Memo, '') AS memo
    ,NULLIF(scl.Desc, '') AS description

    ,NULLIF(scl.UnitOfMeasure, '') AS unit_of_measure

    ,CASE WHEN scl.OverrideUOMSetRef_FullName = '' THEN 'Unassigned' ELSE scl.OverrideUOMSetRef_FullName END AS override_uom_set_full_name
    ,CASE WHEN scl.AccountRef_FullName = '' THEN 'Unassigned' ELSE scl.AccountRef_FullName END AS account_full_name
    ,CASE WHEN scl.ItemRef_FullName = '' THEN 'Unassigned' ELSE scl.ItemRef_FullName END AS item_full_name
    ,CASE WHEN scl.CustomerRef_FullName = '' THEN 'Unassigned' ELSE scl.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN scl.ClassRef_FullName = '' THEN 'Unassigned' ELSE scl.ClassRef_FullName END AS class_full_name

    ,CASE WHEN scl.Cost = '' THEN 0 ELSE CAST(scl.Cost AS DECIMAL(12, 4)) END AS cost
    ,CASE WHEN scl.Amount = '' THEN 0 ELSE CAST(scl.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN scl.Quantity = '' THEN 0 ELSE CAST(scl.Quantity AS DECIMAL(12, 4)) END AS quantity

    ,scl.ChildTag AS child_tag
    ,CAST(scl.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_check_lines AS scl
-- << INCREMENTAL >> --
WHERE scl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill AS cl
    WHERE CAST(cl.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)