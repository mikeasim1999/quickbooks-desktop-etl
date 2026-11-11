SELECT
    sial.TxnLineID AS credit_memo_line_id
    ,sial.TxnID AS credit_memo_id
    ,CASE WHEN sial.ItemRef_ListID = '' THEN '0' ELSE sial.ItemRef_ListID END AS item_id

    ,CASE WHEN sial.ItemRef_FullName = '' THEN 'Unassigned' ELSE sial.ItemRef_FullName END AS item_full_name

    ,CASE WHEN sial.QuantityDifference = '' THEN 0 ELSE CAST(sial.QuantityDifference AS DECIMAL(12, 4)) END AS quantity_difference
    ,CASE WHEN sial.ValueDifference = '' THEN 0 ELSE CAST(sial.ValueDifference AS DECIMAL(12, 4)) END AS value_difference

    ,sial.ChildTag AS child_tag
    ,CAST(sial.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_inventory_adjustment_lines AS sial
-- << INCREMENTAL >> --
WHERE sial.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_inventory_adjustment AS ia
    WHERE CAST(ia.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)