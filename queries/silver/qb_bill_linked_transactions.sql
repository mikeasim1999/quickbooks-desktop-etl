SELECT
    sblt.TxnID AS linked_bill_id

    ,CAST(sblt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(sblt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(sblt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(sblt.LinkType, '') AS link_type

    ,CASE WHEN sblt.Amount = '' THEN 0 ELSE CAST(sblt.Amount AS DECIMAL(12, 4)) END AS amount

    ,sblt.ChildTag AS child_tag
    ,CAST(sblt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_linked_transactions AS sblt
-- << INCREMENTAL >> --
WHERE sblt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill AS b
    WHERE CAST(b.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)