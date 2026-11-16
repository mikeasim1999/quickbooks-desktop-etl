SELECT
    svclt.TxnID AS linked_vendor_credit_id

    ,CAST(svclt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(svclt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(svclt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(svclt.LinkType, '') AS link_type

    ,CASE WHEN svclt.Amount = '' THEN 0 ELSE CAST(svclt.Amount AS DECIMAL(12, 4)) END AS amount

    ,svclt.ChildTag AS child_tag
    ,NOW() AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendorcredit_linked_transactions AS svclt
-- << INCREMENTAL >> --
WHERE svclt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendorcredit AS vc
    WHERE CAST(vc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)