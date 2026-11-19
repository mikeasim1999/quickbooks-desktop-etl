SELECT
    spolt.LinkedTxn_TxnID AS linked_transaction_id
    ,spolt.TxnID AS transaction_id

    ,CAST(spolt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(spolt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(spolt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(spolt.LinkType, '') AS link_type

    ,CASE WHEN spolt.Amount = '' THEN 0 ELSE CAST(spolt.Amount AS DECIMAL(12, 4)) END AS amount

    ,spolt.ChildTag AS child_tag
    ,NOW() AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_purchaseorder_linked_transactions AS spolt
-- << INCREMENTAL >> --
WHERE spolt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_purchaseorder AS po
    WHERE CAST(po.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)