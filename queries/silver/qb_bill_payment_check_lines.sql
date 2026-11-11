SELECT
    sbpcl.TxnID AS bill_payment_check_id
    ,CASE WHEN sbpcl.DiscountAccountRef_ListID = '' THEN '0' ELSE sbpcl.DiscountAccountRef_ListID END AS account_id
    ,CASE WHEN sbpcl.DiscountClassRef_ListID = '' THEN '0' ELSE sbpcl.DiscountClassRef_ListID END AS class_id

    ,TRY_CAST(sbpcl.TxnDate AS DATE) AS transaction_date
    ,TRY_CAST(sbpcl.LinkedTxn_TxnDate AS DATE) AS linked_transaction_date

    ,NULLIF(sbpcl.RefNumber, '') AS reference_number
    ,NULLIF(sbpcl.LinkedTxn_RefNumber, '') AS linked_transaction_reference_number

    ,NULLIF(sbpcl.TxnType, '') AS transaction_type
    ,NULLIF(sbpcl.LinkedTxn_TxnType, '') AS linked_transaction_type

    ,CASE WHEN sbpcl.DiscountAccountRef_FullName = '' THEN 'Unassigned' ELSE sbpcl.DiscountAccountRef_FullName END AS account_full_name
    ,CASE WHEN sbpcl.DiscountClassRef_FullName = '' THEN 'Unassigned' ELSE sbpcl.DiscountClassRef_FullName END AS class_full_name
    ,NULLIF(sbpcl.LinkedTxn_LinkType, '') AS linked_transaction_link_type
    ,CASE WHEN sbpcl.LinkedTxn_TxnID = '' THEN '0' ELSE sbpcl.LinkedTxn_TxnID END AS linked_transaction_id

    ,CASE WHEN sbpcl.LinkedTxn_Amount = '' THEN 0 ELSE CAST(sbpcl.LinkedTxn_Amount AS DECIMAL(12, 4)) END AS linked_transaction_amount
    ,CASE WHEN sbpcl.Amount = '' THEN 0 ELSE CAST(sbpcl.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN sbpcl.DiscountAmount = '' THEN 0 ELSE CAST(sbpcl.DiscountAmount AS DECIMAL(12, 4)) END AS discount_amount
    ,CASE WHEN sbpcl.BalanceRemaining = '' THEN 0 ELSE CAST(sbpcl.BalanceRemaining AS DECIMAL(12, 4)) END AS remaining_balance

    ,NULLIF(sbpcl.ChildTag, '') AS child_tag
    ,CAST(sbpcl.LoadDatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check_lines AS sbpcl
-- << INCREMENTAL >> --
WHERE sbpcl.TxnID IN (
    SELECT TxnID
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check
    WHERE CAST(TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)