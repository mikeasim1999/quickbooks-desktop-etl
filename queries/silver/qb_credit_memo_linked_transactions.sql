SELECT
    scmlt.TxnID AS linked_credit_memo_id

    ,CAST(scmlt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(scmlt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(scmlt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(scmlt.LinkType, '') AS link_type

    ,CASE WHEN scmlt.Amount = '' THEN 0 ELSE CAST(scmlt.Amount AS DECIMAL(12, 4)) END AS amount

    ,scmlt.ChildTag AS child_tag
    ,CAST(scmlt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_memo_linked_transactions AS scmlt
-- << INCREMENTAL >> --
WHERE scmlt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_memo AS cm
    WHERE CAST(cm.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)