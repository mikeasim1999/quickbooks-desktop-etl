SELECT
    srp.TxnID AS receive_payment_id
    ,CASE WHEN srp.CustomerRef_ListID = '' THEN '0' ELSE srp.CustomerRef_ListID END AS customer_id
    ,CASE WHEN srp.ARAccountRef_ListID = '' THEN '0' ELSE srp.ARAccountRef_ListID END AS ar_account_id
    ,CASE WHEN srp.DepositToAccountRef_ListID = '' THEN '0' ELSE srp.DepositToAccountRef_ListID END AS deposit_account_id
    ,CASE WHEN srp.PaymentMethodRef_ListID = '' THEN '0' ELSE srp.PaymentMethodRef_ListID END AS payment_method_id

    ,CAST(srp.TxnDate AS DATE) AS transaction_date

    ,CAST(srp.TxnNumber AS INT) AS transaction_number
    ,NULLIF(srp.RefNumber, '') AS reference_number

    ,CASE WHEN srp.CustomerRef_FullName = '' THEN 'Unassigned' ELSE srp.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN srp.ARAccountRef_FullName = '' THEN 'Unassigned' ELSE srp.ARAccountRef_FullName END AS ar_account_full_name
    ,CASE WHEN srp.DepositToAccountRef_FullName = '' THEN 'Unassigned' ELSE srp.DepositToAccountRef_FullName END AS deposit_account_full_name
    ,CASE WHEN srp.PaymentMethodRef_FullName = '' THEN 'Unassigned' ELSE srp.PaymentMethodRef_FullName END AS payment_method_full_name

    ,CASE WHEN srp.UnusedPayment = '' THEN 0 ELSE CAST(srp.UnusedPayment AS DECIMAL(12, 4)) END AS unused_payments
    ,CASE WHEN srp.UnusedCredits = '' THEN 0 ELSE CAST(srp.UnusedCredits AS DECIMAL(12, 4)) END AS unused_credits
    ,CASE WHEN srp.TotalAmount = '' THEN 0 ELSE CAST(srp.TotalAmount AS DECIMAL(12, 4)) END AS total_amount

    ,NULLIF(srp.EditSequence, '') AS edit_sequence
    ,CAST(srp.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(srp.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(srp.LoadDatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_receive_payment AS srp
-- << INCREMENTAL >> --
WHERE
    CAST(srp.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'