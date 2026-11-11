SELECT
    srpl.TxnID AS receive_payment_id
    ,CASE WHEN srpl.DiscountAccountRef_ListID = '' THEN '0' ELSE srpl.DiscountAccountRef_ListID END AS discount_account_id
    ,CASE WHEN srpl.DiscountClassRef_ListID = '' THEN '0' ELSE srpl.DiscountClassRef_ListID END AS discount_class_id

    ,CAST(srpl.TxnDate AS DATE) AS transaction_date
    ,CAST(srpl.LinkedTxn_TxnDate AS DATE) AS linked_transaction_date

    ,NULLIF(srpl.RefNumber, '') AS reference_number
    ,NULLIF(srpl.LinkedTxn_RefNumber, '') AS linked_transaction_reference_number

    ,NULLIF(srpl.TxnType, '') AS transaction_type
    ,NULLIF(srpl.LinkedTxn_TxnType, '') AS linked_transaction_type

    ,CASE WHEN srpl.DiscountAccountRef_FullName = '' THEN 'Unassigned' ELSE srpl.DiscountAccountRef_FullName END AS discount_account_full_name
    ,CASE WHEN srpl.DiscountClassRef_FullName = '' THEN 'Unassigned' ELSE srpl.DiscountClassRef_FullName END AS discount_class_full_name
    ,NULLIF(srpl.LinkedTxn_LinkType, '') AS linked_transaction_link_type
    ,CASE WHEN srpl.LinkedTxn_TxnID = '' THEN '0' ELSE srpl.LinkedTxn_TxnID END AS linked_transaction_id

    ,CASE WHEN srpl.LinkedTxn_Amount = '' THEN 0 ELSE CAST(srpl.LinkedTxn_Amount AS DECIMAL(12, 4)) END AS linked_transaction_amount
    ,CASE WHEN srpl.Amount = '' THEN 0 ELSE CAST(srpl.Amount AS DECIMAL(12, 4)) END AS amount
    ,CASE WHEN srpl.DiscountAmount = '' THEN 0 ELSE CAST(srpl.DiscountAmount AS DECIMAL(12, 4)) END AS discount_amount
    ,CASE WHEN srpl.BalanceRemaining = '' THEN 0 ELSE CAST(srpl.BalanceRemaining AS DECIMAL(12, 4)) END AS remaining_balance

    ,NULLIF(srpl.ChildTag, '') AS child_tag
    ,CAST(srpl.LoadDatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment_lines AS srpl
-- << INCREMENTAL >> --
WHERE srpl.TxnID IN (
    SELECT TxnID
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment AS rp
    WHERE CAST(rp.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)