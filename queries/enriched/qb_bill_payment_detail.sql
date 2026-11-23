WITH base AS (
    -- AP Side
    SELECT
        CONCAT(bpcl.bill_payment_check_id, '_', bpcl.linked_transaction_id, '_AP') AS transaction_line_id
        ,bpc.bill_payment_check_id AS transaction_id
        ,bpcl.linked_transaction_id AS linked_transaction_id
        ,bpc.ap_account_id AS account_id
        ,bpc.vendor_id AS vendor_id
        ,bpcl.class_id AS class_id
        ,bpc.transaction_date AS transaction_date
        ,bpc.transaction_number AS transaction_number
        ,bpc.reference_number AS reference_number
        ,CONCAT('BP', bpc.transaction_number) AS type_based_transaction_number
        ,bpc.is_to_be_printed AS is_to_be_printed
        ,'Bill Payment Check' AS transaction_type
        ,'AP' AS line_type
        ,bpcl.child_tag AS line_detail_type
        ,bpc.memo AS line_description
        ,bpcl.amount AS amount
        ,bpcl.discount_amount AS discount_amount
        ,bpcl.remaining_balance AS remaining_balance
        ,bpc.created_datetime AS created_datetime
        ,bpc.last_modified_datetime AS last_modified_datetime
        ,bpc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check_lines AS bpcl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check AS bpc
        ON bpcl.bill_payment_check_id = bpc.bill_payment_check_id

    UNION ALL

    -- Bank Side (allocated per applied bill)
    SELECT
        CONCAT(bpcl.bill_payment_check_id, '_', bpcl.linked_transaction_id, '_BANK') AS transaction_line_id
        ,bpc.bill_payment_check_id AS transaction_id
        ,bpcl.linked_transaction_id AS linked_transaction_id
        ,bpc.bank_account_id AS account_id
        ,bpc.vendor_id AS vendor_id
        ,'0' AS class_id
        ,bpc.transaction_date AS transaction_date
        ,bpc.transaction_number AS transaction_number
        ,bpc.reference_number AS reference_number
        ,CONCAT('BP', bpc.transaction_number) AS type_based_transaction_number
        ,bpc.is_to_be_printed AS is_to_be_printed
        ,'Bill Payment Check' AS transaction_type
        ,'Bank' AS line_type
        ,bpcl.child_tag AS line_detail_type
        ,bpc.memo AS line_description
        ,bpcl.amount - bpcl.discount_amount AS amount
        ,0 AS discount_amount
        ,0 AS remaining_balance
        ,bpc.created_datetime AS created_datetime
        ,bpc.last_modified_datetime AS last_modified_datetime
        ,bpc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check_lines AS bpcl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check AS bpc
        ON bpcl.bill_payment_check_id = bpc.bill_payment_check_id

    UNION ALL

    -- Discount Side
    SELECT
        CONCAT(bpcl.bill_payment_check_id, '_', bpcl.linked_transaction_id, '_DISC') AS transaction_line_id
        ,bpc.bill_payment_check_id AS transaction_id
        ,bpcl.linked_transaction_id AS linked_transaction_id
        ,bpcl.account_id AS account_id
        ,bpc.vendor_id AS vendor_id
        ,bpcl.class_id AS class_id
        ,bpc.transaction_date AS transaction_date
        ,bpc.transaction_number AS transaction_number
        ,bpc.reference_number AS reference_number
        ,CONCAT('BP', bpc.transaction_number) AS type_based_transaction_number
        ,bpc.is_to_be_printed AS is_to_be_printed
        ,'Bill Payment Check' AS transaction_type
        ,'Discount' AS line_type
        ,bpcl.child_tag AS line_detail_type
        ,NULL AS line_description
        ,bpcl.discount_amount AS amount
        ,bpcl.discount_amount AS discount_amount
        ,0 AS remaining_balance
        ,bpc.created_datetime AS created_datetime
        ,bpc.last_modified_datetime AS last_modified_datetime
        ,bpc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check_lines AS bpcl
    INNER JOIN {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check AS bpc
        ON bpcl.bill_payment_check_id = bpc.bill_payment_check_id
    WHERE bpcl.discount_amount <> 0
)
SELECT *
FROM base
-- << INCREMENTAL >> --
WHERE last_modified_datetime >= '{WATERMARK_DATE}'