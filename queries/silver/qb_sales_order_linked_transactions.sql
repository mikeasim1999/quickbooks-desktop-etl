SELECT
    ssolt.TxnID AS linked_sales_order_id

    ,CAST(ssolt.TxnDate AS DATE) AS transaction_date

    ,NULLIF(ssolt.RefNumber, '') AS reference_number

    ,TRIM(REGEXP_REPLACE(ssolt.TxnType, '([A-Z])', ' $1')) AS transaction_type
    ,NULLIF(ssolt.LinkType, '') AS link_type

    ,CASE WHEN ssolt.Amount = '' THEN 0 ELSE CAST(ssolt.Amount AS DECIMAL(12, 4)) END AS amount

    ,ssolt.ChildTag AS child_tag
    ,CAST(ssolt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_order_linked_transactions AS ssolt
-- << INCREMENTAL >> --
WHERE ssolt.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_order AS so
    WHERE CAST(so.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)