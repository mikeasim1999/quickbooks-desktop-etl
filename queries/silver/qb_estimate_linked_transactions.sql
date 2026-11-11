SELECT
    selt.TxnID AS linked_estimate_id

    ,CAST(selt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(selt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(selt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(selt.LinkType, '') AS link_type

    ,CASE WHEN selt.Amount = '' THEN 0 ELSE CAST(selt.Amount AS DECIMAL(12, 4)) END AS amount

    ,selt.ChildTag AS child_tag
    ,CAST(selt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_estimate_linked_transactions AS selt
-- << INCREMENTAL >> --
WHERE selt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_estimate AS e
    WHERE CAST(e.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)