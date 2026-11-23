WITH base AS (
    -- Expense / Item Lines
    SELECT
        cl.check_line_id AS transaction_line_id
        ,c.check_id AS transaction_id
        ,cl.account_id AS account_id
        ,c.vendor_id AS vendor_id
        ,cl.customer_id AS customer_id
        ,cl.class_id AS class_id
        ,cl.item_id AS item_id
        ,'0' AS terms_id
        ,c.transaction_date AS transaction_date
        ,c.transaction_number AS transaction_number
        ,c.reference_number AS reference_number
        ,CONCAT('CK', c.transaction_number) AS type_based_transaction_number
        ,c.is_pending AS is_pending
        ,c.is_to_be_printed AS is_to_be_printed
        ,'Check' AS transaction_type
        ,CASE
            WHEN cl.child_tag = 'ExpenseLineRet' THEN 'Expense'
            WHEN cl.child_tag = 'ItemLineRet' THEN 'Item'
            ELSE 'Other'
         END AS line_type
        ,cl.child_tag AS line_detail_type
        ,cl.description AS line_description
        ,cl.memo AS line_memo
        ,cl.amount AS amount
        ,cl.quantity AS quantity
        ,cl.cost AS unit_cost
        ,c.created_datetime AS created_datetime
        ,c.last_modified_datetime AS last_modified_datetime
        ,c.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_check_lines AS cl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_check AS c
        ON cl.check_id = c.check_id

    UNION ALL

    -- Bank Side (header)
    SELECT
        CONCAT(c.check_id, '_BANK') AS transaction_line_id
        ,c.check_id AS transaction_id
        ,c.account_id AS account_id
        ,c.vendor_id AS vendor_id
        ,'0' AS customer_id
        ,'0' AS class_id
        ,'0' AS item_id
        ,'0' AS terms_id
        ,c.transaction_date AS transaction_date
        ,c.transaction_number AS transaction_number
        ,c.reference_number AS reference_number
        ,CONCAT('CK', c.transaction_number) AS type_based_transaction_number
        ,c.is_pending AS is_pending
        ,c.is_to_be_printed AS is_to_be_printed
        ,'Check' AS transaction_type
        ,'Bank' AS line_type
        ,NULL AS line_detail_type
        ,NULL AS line_description
        ,NULL AS line_memo
        ,c.amount AS amount
        ,NULL AS quantity
        ,NULL AS unit_cost
        ,c.created_datetime AS created_datetime
        ,c.last_modified_datetime AS last_modified_datetime
        ,c.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_check AS c
)
SELECT *
FROM base