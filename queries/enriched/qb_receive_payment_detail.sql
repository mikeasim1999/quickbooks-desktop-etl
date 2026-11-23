WITH base AS (
    -- AR Side
    SELECT
        CONCAT(rpl.receive_payment_id, '_', rpl.linked_transaction_id, '_AR') AS transaction_line_id
        ,rp.receive_payment_id AS transaction_id
        ,rpl.linked_transaction_id AS linked_transaction_id
        ,rp.ar_account_id AS account_id
        ,rp.customer_id AS customer_id
        ,rpl.discount_class_id AS class_id
        ,rp.payment_method_id AS payment_method_id
        ,rp.transaction_date AS transaction_date
        ,rp.transaction_number AS transaction_number
        ,rp.reference_number AS reference_number
        ,CONCAT('RP', rp.transaction_number) AS type_based_transaction_number
        ,'Receive Payment' AS transaction_type
        ,'AR' AS line_type
        ,rpl.child_tag AS line_detail_type
        ,rpl.linked_transaction_type AS linked_transaction_type
        ,rpl.amount AS amount
        ,rpl.discount_amount AS discount_amount
        ,rpl.remaining_balance AS remaining_balance
        ,rp.unused_payments AS unused_payments
        ,rp.unused_credits AS unused_credits
        ,rp.created_datetime AS created_datetime
        ,rp.last_modified_datetime AS last_modified_datetime
        ,rp.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment_lines AS rpl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment AS rp
        ON rpl.receive_payment_id = rp.receive_payment_id

    UNION ALL

    -- Deposit / Bank Side
    SELECT
        CONCAT(rpl.receive_payment_id, '_', rpl.linked_transaction_id, '_DEP') AS transaction_line_id
        ,rp.receive_payment_id AS transaction_id
        ,rpl.linked_transaction_id AS linked_transaction_id
        ,rp.deposit_account_id AS account_id
        ,rp.customer_id AS customer_id
        ,'0' AS class_id
        ,rp.payment_method_id AS payment_method_id
        ,rp.transaction_date AS transaction_date
        ,rp.transaction_number AS transaction_number
        ,rp.reference_number AS reference_number
        ,CONCAT('RP', rp.transaction_number) AS type_based_transaction_number
        ,'Receive Payment' AS transaction_type
        ,'Deposit' AS line_type
        ,rpl.child_tag AS line_detail_type
        ,rpl.linked_transaction_type AS linked_transaction_type
        ,rpl.amount AS amount
        ,0 AS discount_amount
        ,0 AS remaining_balance
        ,0 AS unused_payments
        ,0 AS unused_credits
        ,rp.created_datetime AS created_datetime
        ,rp.last_modified_datetime AS last_modified_datetime
        ,rp.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment_lines AS rpl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment AS rp
        ON rpl.receive_payment_id = rp.receive_payment_id

    UNION ALL

    -- Discount Side
    SELECT
        CONCAT(rpl.receive_payment_id, '_', rpl.linked_transaction_id, '_DISC') AS transaction_line_id
        ,rp.receive_payment_id AS transaction_id
        ,rpl.linked_transaction_id AS linked_transaction_id
        ,rpl.discount_account_id AS account_id
        ,rp.customer_id AS customer_id
        ,rpl.discount_class_id AS class_id
        ,rp.payment_method_id AS payment_method_id
        ,rp.transaction_date AS transaction_date
        ,rp.transaction_number AS transaction_number
        ,rp.reference_number AS reference_number
        ,CONCAT('RP', rp.transaction_number) AS type_based_transaction_number
        ,'Receive Payment' AS transaction_type
        ,'Discount' AS line_type
        ,rpl.child_tag AS line_detail_type
        ,rpl.linked_transaction_type AS linked_transaction_type
        ,rpl.discount_amount AS amount
        ,rpl.discount_amount AS discount_amount
        ,0 AS remaining_balance
        ,0 AS unused_payments
        ,0 AS unused_credits
        ,rp.created_datetime AS created_datetime
        ,rp.last_modified_datetime AS last_modified_datetime
        ,rp.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment_lines AS rpl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment AS rp
        ON rpl.receive_payment_id = rp.receive_payment_id
    WHERE rpl.discount_amount <> 0
)
SELECT *
FROM base
-- << INCREMENTAL >> --
WHERE last_modified_datetime >= '{WATERMARK_DATE}'