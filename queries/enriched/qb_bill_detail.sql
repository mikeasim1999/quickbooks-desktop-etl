WITH base AS (
    SELECT
        bl.bill_line_id  AS transaction_line_id
        ,b.bill_id AS transaction_id
        ,bl.account_id AS account_id
        ,b.vendor_id AS vendor_id
        ,COALESCE(NULLIF(bl.customer_id, '0'), '0') AS customer_id
        ,COALESCE(NULLIF(bl.class_id, '0'), '0')  AS class_id
        ,bl.item_id AS item_id
        ,b.terms_id AS terms_id
        ,b.transaction_date AS transaction_date
        ,b.due_date AS due_date
        ,b.transaction_number AS transaction_number
        ,b.reference_number AS reference_number
        ,CONCAT('BL', b.transaction_number) AS type_based_transaction_number
        ,b.is_pending AS is_pending
        ,b.is_paid AS is_paid
        ,'Bill' AS transaction_type
        ,REGEXP_EXTRACT(bl.xml_child_tag, '^[A-Z][a-z]*', 0)  AS line_type
        ,bl.xml_child_tag AS line_detail_type
        ,bl.description AS line_description
        ,bl.memo AS line_memo
        ,bl.amount AS amount
        ,0 AS amount_open
        ,0 AS amount_due
        ,bl.quantity AS quantity
        ,bl.cost AS unit_cost
        ,b.created_datetime AS created_datetime
        ,b.last_modified_datetime AS last_modified_datetime
        ,b.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_lines AS bl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_bill AS b
        ON bl.bill_id = b.bill_id
    UNION ALL
    SELECT
        CONCAT(b.bill_id, '_AP') AS transaction_line_id
        ,b.bill_id AS transaction_id
        ,b.account_id AS account_id
        ,b.vendor_id AS vendor_id
        ,'0' AS customer_id
        ,'0' AS class_id
        ,'0' AS item_id
        ,b.terms_id AS terms_id
        ,b.transaction_date AS transaction_date
        ,b.due_date AS due_date
        ,b.transaction_number AS transaction_number
        ,b.reference_number AS reference_number
        ,CONCAT('BL', b.transaction_number) AS type_based_transaction_number
        ,b.is_pending AS is_pending
        ,b.is_paid AS is_paid
        ,'Bill' AS transaction_type
        ,'AP' AS line_type
        ,'AccountsPayableLineRet' AS line_detail_type
        ,'Main Line' AS line_description
        ,NULL AS line_memo
        ,b.amount_due AS amount
        ,b.amount_open AS amount_open
        ,b.amount_due AS amount_due
        ,0 AS quantity
        ,0 AS unit_cost
        ,b.created_datetime AS created_datetime
        ,b.last_modified_datetime AS last_modified_datetime
        ,b.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill AS b
)
SELECT *
FROM base
-- << INCREMENTAL >> --
WHERE last_modified_datetime >= '{WATERMARK_DATE}'
