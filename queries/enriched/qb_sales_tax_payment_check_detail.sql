WITH base AS (
    -- Sales Tax Liability Side
    SELECT
        stpcl.sales_tax_payment_check_line_id AS transaction_line_id
        ,stpc.sales_tax_payment_check_id AS transaction_id
        ,NULL AS linked_transaction_id
        ,'0' AS account_id
        ,stpcl.item_sales_tax_ref_list_id AS item_sales_tax_id
        ,stpc.vendor_id AS vendor_id
        ,stpc.transaction_date AS transaction_date
        ,stpc.transaction_number AS transaction_number
        ,stpc.reference_number AS reference_number
        ,CONCAT('ST', stpc.transaction_number) AS type_based_transaction_number
        ,stpc.is_to_be_printed AS is_to_be_printed
        ,'Sales Tax Payment' AS transaction_type
        ,'Sales Tax' AS line_type
        ,stpcl.child_tag AS line_detail_type
        ,stpc.memo AS line_description
        ,stpcl.amount AS amount
        ,stpc.created_datetime AS created_datetime
        ,stpc.last_modified_datetime AS last_modified_datetime
        ,stpc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_payment_check_lines AS stpcl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_payment_check AS stpc
        ON stpcl.sales_tax_payment_check_id = stpc.sales_tax_payment_check_id

    UNION ALL

    -- Bank Side
    SELECT
        CONCAT(stpc.sales_tax_payment_check_id, '_BANK') AS transaction_line_id
        ,stpc.sales_tax_payment_check_id AS transaction_id
        ,NULL AS linked_transaction_id
        ,stpc.account_id AS account_id
        ,'0' AS item_sales_tax_id
        ,stpc.vendor_id AS vendor_id
        ,stpc.transaction_date AS transaction_date
        ,stpc.transaction_number AS transaction_number
        ,stpc.reference_number AS reference_number
        ,CONCAT('ST', stpc.transaction_number) AS type_based_transaction_number
        ,stpc.is_to_be_printed AS is_to_be_printed
        ,'Sales Tax Payment' AS transaction_type
        ,'Bank' AS line_type
        ,NULL AS line_detail_type
        ,stpc.memo AS line_description
        ,stpc.total_amount AS amount
        ,stpc.created_datetime AS created_datetime
        ,stpc.last_modified_datetime AS last_modified_datetime
        ,stpc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_payment_check AS stpc
)
SELECT *
FROM base
-- << INCREMENTAL >> --
WHERE last_modified_datetime >= '{WATERMARK_DATE}'