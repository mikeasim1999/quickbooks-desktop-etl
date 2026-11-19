SELECT
    sirlt.LinkedTxn_TxnID AS linked_transaction_id
    ,sirlt.TxnID AS transaction_id

    ,CAST(sirlt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(sirlt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(sirlt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(sirlt.LinkType, '') AS link_type

    ,CASE WHEN sirlt.Amount = '' THEN 0 ELSE CAST(sirlt.Amount AS DECIMAL(12, 4)) END AS amount

    ,sirlt.ChildTag AS child_tag
    ,NOW() AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_itemreceipt_linked_transactions AS sirlt
-- << INCREMENTAL >> --
WHERE sirlt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_itemreceipt AS ir
    WHERE CAST(ir.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)