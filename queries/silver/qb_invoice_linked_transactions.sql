SELECT
    silt.TxnID AS linked_invoice_id

    ,CAST(silt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(silt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(silt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(silt.LinkType, '') AS link_type

    ,CASE WHEN silt.Amount = '' THEN 0 ELSE CAST(silt.Amount AS DECIMAL(12, 4)) END AS amount

    ,silt.ChildTag AS child_tag
    ,CAST(silt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_invoice_linked_transactions AS silt
-- << INCREMENTAL >> --
WHERE silt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_invoice AS i
    WHERE CAST(i.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)