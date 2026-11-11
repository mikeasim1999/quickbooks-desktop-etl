SELECT
    sirlt.TxnID AS linked_item_receipt_id

    ,CAST(sirlt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(sirlt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(sirlt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(sirlt.LinkType, '') AS link_type

    ,CASE WHEN sirlt.Amount = '' THEN 0 ELSE CAST(sirlt.Amount AS DECIMAL(12, 4)) END AS amount

    ,sirlt.ChildTag AS child_tag
    ,CAST(sirlt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_receipt_linked_transactions AS sirlt
-- << INCREMENTAL >> --
WHERE sirlt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_receipt AS ir
    WHERE CAST(ir.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)