SELECT
    spolt.TxnID AS linked_purchase_order_id

    ,CAST(spolt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(spolt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(spolt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(spolt.LinkType, '') AS link_type

    ,CASE WHEN spolt.Amount = '' THEN 0 ELSE CAST(spolt.Amount AS DECIMAL(12, 4)) END AS amount

    ,spolt.ChildTag AS child_tag
    ,CAST(spolt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_purchase_order_linked_transactions AS spolt
-- << INCREMENTAL >> --
WHERE spolt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_purchase_order AS po
    WHERE CAST(po.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)