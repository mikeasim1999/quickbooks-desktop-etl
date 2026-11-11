SELECT
    sstpcl.TxnLineID AS sales_tax_payment_check_line_id
    ,sstpcl.TxnID AS sales_tax_payment_check_id
    ,CASE WHEN sstpcl.ItemSalesTaxref_ListID = '' THEN '0' ELSE sstpcl.ItemSalesTaxref_ListID END AS item_sales_tax_ref_list_id

    ,CASE WHEN sstpcl.ItemSalesTaxref_FullName = '' THEN 'Unassigned' ELSE sstpcl.ItemSalesTaxref_FullName END AS item_sales_tax_ref_full_name

    ,CASE WHEN sstpcl.Amount = '' THEN 0 ELSE CAST(sstpcl.Amount AS DECIMAL(12, 4)) END AS amount

    ,sstpcl.ChildTag AS child_tag
    ,CAST(sstpcl.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_payment_check_lines AS sstpcl
-- << INCREMENTAL >> --
WHERE sstpcl.TxnID IN (
    SELECT TxnID 
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_payment_check AS stpc
    WHERE CAST(stpc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
)