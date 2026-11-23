WITH base AS (
    -- Expense / Item Lines
    SELECT
        ccl.credit_card_charge_line_id AS transaction_line_id
        ,cc.credit_card_charge_id AS transaction_id
        ,ccl.account_id AS account_id
        ,cc.vendor_id AS vendor_id
        ,ccl.customer_id AS customer_id
        ,ccl.class_id AS class_id
        ,ccl.item_id AS item_id
        ,cc.transaction_date AS transaction_date
        ,cc.transaction_number AS transaction_number
        ,CONCAT('CC', cc.transaction_number) AS type_based_transaction_number
        ,'Credit Card Charge' AS transaction_type
        ,CASE
            WHEN ccl.child_tag = 'ExpenseLineRet' THEN 'Expense'
            WHEN ccl.child_tag = 'ItemLineRet' THEN 'Item'
            ELSE 'Other'
         END AS line_type
        ,ccl.child_tag AS line_detail_type
        ,ccl.billable_status AS billable_status
        ,ccl.description AS line_description
        ,ccl.amount AS amount
        ,ccl.quantity AS quantity
        ,ccl.cost AS unit_cost
        ,cc.created_datetime AS created_datetime
        ,cc.last_modified_datetime AS last_modified_datetime
        ,cc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_card_charge_lines AS ccl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_credit_card_charge AS cc
        ON ccl.credit_card_charge_id = cc.credit_card_charge_id

    UNION ALL

    -- Credit Card Liability Side (header)
    SELECT
        CONCAT(cc.credit_card_charge_id, '_CC') AS transaction_line_id
        ,cc.credit_card_charge_id AS transaction_id
        ,cc.account_id AS account_id
        ,cc.vendor_id AS vendor_id
        ,'0' AS customer_id
        ,'0' AS class_id
        ,'0' AS item_id
        ,cc.transaction_date AS transaction_date
        ,cc.transaction_number AS transaction_number
        ,CONCAT('CC', cc.transaction_number) AS type_based_transaction_number
        ,'Credit Card Charge' AS transaction_type
        ,'Credit Card' AS line_type
        ,NULL AS line_detail_type
        ,NULL AS billable_status
        ,NULL AS line_description
        ,cc.amount AS amount
        ,NULL AS quantity
        ,NULL AS unit_cost
        ,cc.created_datetime AS created_datetime
        ,cc.last_modified_datetime AS last_modified_datetime
        ,cc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_card_charge AS cc
)
SELECT *
FROM base
-- << INCREMENTAL >> --
WHERE last_modified_datetime >= '{WATERMARK_DATE}'