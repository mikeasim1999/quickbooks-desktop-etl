SELECT
    sclt.TxnID AS linked_check_id

    ,CAST(sclt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(sclt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(sclt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(sclt.LinkType, '') AS link_type

    ,CASE WHEN sclt.Amount = '' THEN 0 ELSE CAST(sclt.Amount AS DECIMAL(12, 4)) END AS amount

    ,sclt.ChildTag AS child_tag
    ,CAST(sclt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_check_linked_transactions AS sclt
-- << INCREMENTAL >> --
WHERE sclt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_check AS c
    WHERE CAST(c.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)