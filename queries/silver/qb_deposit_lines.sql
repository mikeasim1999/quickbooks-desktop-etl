SELECT
    sdl.TxnLineID AS deposit_line_id
    ,sdl.TxnID AS deposit_id
    ,CASE WHEN sdl.AccountRef_ListID = '' THEN '0' ELSE sdl.AccountRef_ListID END AS account_id
    ,CASE WHEN sdl.ClassRef_ListID = '' THEN '0' ELSE sdl.ClassRef_ListID END AS class_id
    ,CASE WHEN sdl.EntityRef_ListID = '' THEN '0' ELSE sdl.EntityRef_ListID END AS customer_id
    ,CASE WHEN sdl.PaymentMethodRef_ListID = '' THEN '0' ELSE sdl.PaymentMethodRef_ListID END AS payment_method_id
    ,NULLIF(sdl.PaymentTxnLineID, '') AS payment_txn_line_id

    ,NULLIF(sdl.CheckNumber, '') AS check_number
    ,TRIM(REGEXP_REPLACE(sdl.TxnType, '([A-Z])', ' $1')) AS deposit_type

    ,NULLIF(sdl.Memo, '') AS memo

    ,CASE WHEN sdl.AccountRef_FullName = '' THEN 'Unassigned' ELSE sdl.AccountRef_FullName END AS account_full_name
    ,CASE WHEN sdl.ClassRef_FullName = '' THEN 'Unassigned' ELSE sdl.ClassRef_FullName END AS class_full_name
    ,CASE WHEN sdl.EntityRef_FullName = '' THEN 'Unassigned' ELSE sdl.EntityRef_FullName END AS customer_full_name
    ,CASE WHEN sdl.PaymentMethodRef_FullName = '' THEN 'Unassigned' ELSE sdl.PaymentMethodRef_FullName END AS payment_method_full_name

    ,CASE WHEN sdl.Amount = '' THEN 0 ELSE CAST(sdl.Amount AS DECIMAL(12, 4)) END AS amount

    ,sdl.ChildTag AS child_tag
    ,CAST(sdl.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_deposit_lines AS sdl
-- << INCREMENTAL >> --
WHERE sdl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_deposit AS d
    WHERE CAST(d.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)