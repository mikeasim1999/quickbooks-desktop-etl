SELECT
    scccl.TxnLineID AS credit_card_charge_line_id
    ,scccl.TxnID AS credit_card_charge_id
    ,CASE WHEN scccl.CustomerRef_ListID = '' THEN '0' ELSE scccl.CustomerRef_ListID END AS customer_id
    ,CASE WHEN scccl.ItemRef_ListID = '' THEN '0' ELSE scccl.ItemRef_ListID END AS item_id
    ,CASE WHEN scccl.AccountRef_ListID = '' THEN '0' ELSE scccl.AccountRef_ListID END AS account_id
    ,CASE WHEN scccl.ClassRef_ListID = '' THEN '0' ELSE scccl.ClassRef_ListID END AS class_id

    ,TRIM(REGEXP_REPLACE(scccl.BillableStatus, '([A-Z])', ' $1')) AS billable_status

    ,NULLIF(scccl.Desc, '') AS description

    ,CASE WHEN scccl.CustomerRef_FullName = '' THEN 'Unassigned' ELSE scccl.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN scccl.ItemRef_FullName = '' THEN 'Unassigned' ELSE scccl.ItemRef_FullName END AS item_full_name
    ,CASE WHEN scccl.AccountRef_FullName = '' THEN 'Unassigned' ELSE scccl.AccountRef_FullName END AS account_full_name
    ,CASE WHEN scccl.ClassRef_FullName = '' THEN 'Unassigned' ELSE scccl.ClassRef_FullName END AS class_full_name

    ,CASE WHEN scccl.Cost = '' THEN 0 ELSE CAST(scccl.Cost AS DECIMAL(12, 4)) END AS cost
    ,CASE WHEN scccl.Amount = '' THEN 0 ELSE CAST(scccl.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN scccl.Quantity = '' THEN 0 ELSE CAST(scccl.Quantity AS DECIMAL(12, 4)) END AS quantity

    ,scccl.ChildTag AS child_tag
    ,CAST(scccl.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_card_charge_lines AS scccl
-- << INCREMENTAL >> --
WHERE scccl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_card_charge AS ccc
    WHERE CAST(ccc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)