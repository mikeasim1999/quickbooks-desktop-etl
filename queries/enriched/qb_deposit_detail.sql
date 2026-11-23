WITH base AS (
    -- Deposit Lines
    SELECT
        dl.deposit_line_id AS transaction_line_id
        ,d.deposit_id AS transaction_id
        ,dl.payment_txn_line_id AS linked_transaction_id
        ,dl.account_id AS account_id
        ,dl.customer_id AS entity_id
        ,dl.class_id AS class_id
        ,dl.payment_method_id AS payment_method_id
        ,d.transaction_date AS transaction_date
        ,d.transaction_number AS transaction_number
        ,CONCAT('DP', d.transaction_number) AS type_based_transaction_number
        ,'Deposit' AS transaction_type
        ,dl.deposit_type AS line_type
        ,dl.child_tag AS line_detail_type
        ,dl.memo AS line_description
        ,dl.check_number AS check_number
        ,dl.amount AS amount
        ,d.created_datetime AS created_datetime
        ,d.last_modified_datetime AS last_modified_datetime
        ,d.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_deposit_lines AS dl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_deposit AS d
        ON dl.deposit_id = d.deposit_id

    UNION ALL

    -- Bank Side (header)
    SELECT
        CONCAT(d.deposit_id, '_BANK') AS transaction_line_id
        ,d.deposit_id AS transaction_id
        ,NULL AS linked_transaction_id
        ,d.account_id AS account_id
        ,'0' AS entity_id
        ,'0' AS class_id
        ,'0' AS payment_method_id
        ,d.transaction_date AS transaction_date
        ,d.transaction_number AS transaction_number
        ,CONCAT('DP', d.transaction_number) AS type_based_transaction_number
        ,'Deposit' AS transaction_type
        ,'Bank' AS line_type
        ,NULL AS line_detail_type
        ,d.memo AS line_description
        ,NULL AS check_number
        ,d.deposit_amount AS amount
        ,d.created_datetime AS created_datetime
        ,d.last_modified_datetime AS last_modified_datetime
        ,d.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_deposit AS d
)
SELECT *
FROM base
-- << INCREMENTAL >> --
WHERE last_modified_datetime >= '{WATERMARK_DATE}'