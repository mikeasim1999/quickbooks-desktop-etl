SELECT
    sjel.TxnLineID AS journal_entry_line_id
    ,sjel.TxnID AS journal_entry_id
    ,CASE WHEN sjel.AccountRef_ListID = '' THEN '0' ELSE sjel.AccountRef_ListID END AS account_id
    ,CASE WHEN sjel.ClassRef_ListID = '' THEN '0' ELSE sjel.ClassRef_ListID END AS class_id
    ,CASE WHEN sjel.EntityRef_ListID = '' THEN '0' ELSE sjel.EntityRef_ListID END AS entity_id

    ,CASE WHEN sjel.BillableStatus = '' THEN 'Unassigned' ELSE TRIM(REGEXP_REPLACE(sjel.BillableStatus, '([A-Z])', ' $1')) END AS billable_status

    ,NULLIF(sjel.Memo, '') AS memo

    ,CASE WHEN sjel.AccountRef_FullName = '' THEN 'Unassigned' ELSE sjel.AccountRef_FullName END AS account_full_name
    ,CASE WHEN sjel.ClassRef_FullName = '' THEN 'Unassigned' ELSE sjel.ClassRef_FullName END AS class_full_name
    ,CASE WHEN sjel.EntityRef_FullName = '' THEN 'Unassigned' ELSE sjel.EntityRef_FullName END AS entity_full_name

    ,CASE WHEN sjel.Amount = '' THEN 0 ELSE CAST(sjel.Amount AS DECIMAL(12, 4)) END AS amount

    ,sjel.ChildTag AS child_tag
    ,CAST(sjel.loaddatetime AS TIMESTAMP) AS load_datetime
FROM analytics_lakehouse_dev.bronze.qb_journal_entry_lines AS sjel
-- << INCREMENTAL >> --
WHERE sjel.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_journal_entry AS je
    WHERE CAST(je.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)