WITH general_ledger AS (
    SELECT
        sb.bill_id AS transaction_id
        ,sb.account_id AS account_id
        ,'0' AS customer_id
        ,sb.vendor_id AS vendor_id
        ,'0' AS class_id
        ,sb.terms_id AS terms_id
        ,sb.transaction_date AS transaction_date
        ,sb.due_date AS due_date
        ,NULL AS ship_date
        ,sb.transaction_number AS transaction_number
        ,sb.reference_number AS reference_number
        ,CONCAT_WS('', 'BL',sb.transaction_number) AS type_based_transaction_number
        ,sb.is_pending AS is_pending
        ,sb.is_paid AS is_paid
        ,NULL AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Bill' AS transaction_type
        ,sb.amount_open AS amount
        ,sb.amount_open AS amount_open
        ,sb.amount_due AS amount_due
        ,sb.created_datetime AS created_datetime
        ,sb.last_modified_datetime AS last_modified_datetime
        ,sb.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill AS sb
    UNION ALL
    SELECT
        sbpcap.bill_payment_check_id AS transaction_id
        ,sbpcap.ap_account_id AS account_id
        ,'0' AS customer_id
        ,sbpcap.vendor_id AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,sbpcap.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,sbpcap.transaction_number AS transaction_number
        ,sbpcap.reference_number AS reference_number
        ,CONCAT_WS('', 'BPAP',sbpcap.transaction_number) AS type_based_transaction_number
        ,NULL AS is_pending
        ,NULL AS is_paid
        ,sbpcap.is_to_be_printed AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Bill Payment AP' AS transaction_type
        ,sbpcap.amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,sbpcap.created_datetime AS created_datetime
        ,sbpcap.last_modified_datetime AS last_modified_datetime
        ,sbpcap.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check AS sbpcap
    UNION ALL
    SELECT
        sbpcba.bill_payment_check_id AS transaction_id
        ,sbpcba.bank_account_id AS account_id
        ,'0' AS customer_id
        ,sbpcba.vendor_id AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,sbpcba.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,sbpcba.transaction_number AS transaction_number
        ,sbpcba.reference_number AS reference_number
        ,CONCAT_WS('', 'BPB',sbpcba.transaction_number) AS type_based_transaction_number
        ,NULL AS is_pending
        ,NULL AS is_paid
        ,sbpcba.is_to_be_printed AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Bill Payment Bank' AS transaction_type
        ,sbpcba.amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,sbpcba.created_datetime AS created_datetime
        ,sbpcba.last_modified_datetime AS last_modified_datetime
        ,sbpcba.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_bill_payment_check AS sbpcba
    UNION ALL
    SELECT
        sc.check_id AS transaction_id
        ,sc.account_id AS account_id
        ,'0' AS customer_id
        ,sc.vendor_id AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,sc.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,sc.transaction_number AS transaction_number
        ,sc.reference_number AS reference_number
        ,CONCAT_WS('', 'CK',sc.transaction_number) AS type_based_transaction_number
        ,sc.is_pending AS is_pending
        ,NULL AS is_paid
        ,sc.is_to_be_printed AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Check' AS transaction_type
        ,sc.amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,sc.created_datetime AS created_datetime
        ,sc.last_modified_datetime AS last_modified_datetime
        ,sc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_check AS sc
    UNION ALL
    SELECT
        sccc.credit_card_charge_id AS transaction_id
        ,sccc.account_id AS account_id
        ,'0' AS customer_id
        ,sccc.vendor_id AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,sccc.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,sccc.transaction_number AS transaction_number
        ,NULL AS reference_number
        ,CONCAT_WS('', 'CC',sccc.transaction_number) AS type_based_transaction_number
        ,NULL AS is_pending
        ,NULL AS is_paid
        ,NULL AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Credit Card Charge' AS transaction_type
        ,sccc.amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,sccc.created_datetime AS created_datetime
        ,sccc.last_modified_datetime AS last_modified_datetime
        ,sccc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_card_charge AS sccc
    UNION ALL
    SELECT
        scm.credit_memo_id AS transaction_id
        ,scm.account_id AS account_id
        ,scm.customer_id AS customer_id
        ,'0' AS vendor_id
        ,scm.class_id AS class_id
        ,'0' AS terms_id
        ,scm.transaction_date AS transaction_date
        ,scm.due_date AS due_date
        ,scm.ship_date AS ship_date
        ,scm.transaction_number AS transaction_number
        ,scm.reference_number AS reference_number
        ,CONCAT_WS('', 'CM',scm.transaction_number) AS type_based_transaction_number
        ,scm.is_pending AS is_pending
        ,NULL AS is_paid
        ,scm.is_to_be_printed AS is_to_be_printed
        ,scm.is_to_be_emailed AS is_to_be_emailed
        ,'Credit Memo' AS transaction_type
        ,scm.total_amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,scm.created_datetime AS created_datetime
        ,scm.last_modified_datetime AS last_modified_datetime
        ,scm.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_credit_memo AS scm
    UNION ALL
    SELECT
        sd.deposit_id AS transaction_id
        ,sd.account_id AS account_id
        ,'0' AS customer_id
        ,'0' AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,sd.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,sd.transaction_number AS transaction_number
        ,NULL AS reference_number
        ,CONCAT_WS('', 'DP',sd.transaction_number) AS type_based_transaction_number
        ,NULL AS is_pending
        ,NULL AS is_paid
        ,NULL AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Deposit' AS transaction_type
        ,sd.deposit_amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,sd.created_datetime AS created_datetime
        ,sd.last_modified_datetime AS last_modified_datetime
        ,sd.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_deposit AS sd
    UNION ALL
    SELECT
        si.invoice_id AS transaction_id
        ,si.account_id AS account_id
        ,si.customer_id AS customer_id
        ,'0' AS vendor_id
        ,si.class_id AS class_id
        ,si.terms_id AS terms_id
        ,si.transaction_date AS transaction_date
        ,si.due_date AS due_date
        ,si.ship_date AS ship_date
        ,si.transaction_number AS transaction_number
        ,si.reference_number AS reference_number
        ,CONCAT_WS('', 'IV',si.transaction_number) AS type_based_transaction_number
        ,si.is_pending AS is_pending
        ,si.is_paid AS is_paid
        ,si.is_to_be_printed AS is_to_be_printed
        ,si.is_to_be_emailed AS is_to_be_emailed
        ,'Invoice' AS transaction_type
        ,si.subtotal_amount AS amount
        ,NULL AS amount_open
        ,si.balance_remaining_amount AS amount_due
        ,si.created_datetime AS created_datetime
        ,si.last_modified_datetime AS last_modified_datetime
        ,si.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_invoice AS si
    UNION ALL
    SELECT
        svc.vendor_credit_id AS transaction_id
        ,svc.account_id AS account_id
        ,'0' AS customer_id
        ,svc.vendor_id AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,svc.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,svc.transaction_number AS transaction_number
        ,svc.reference_number AS reference_number
        ,CONCAT_WS('', 'VC',svc.transaction_number) AS type_based_transaction_number
        ,NULL AS is_pending
        ,NULL AS is_paid
        ,NULL AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Vendor Credit' AS transaction_type
        ,svc.credit_amount AS amount
        ,svc.open_amount AS amount_open
        ,NULL AS amount_due
        ,svc.created_datetime AS created_datetime
        ,svc.last_modified_datetime AS last_modified_datetime
        ,svc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendor_credit AS svc
    UNION ALL
    SELECT
        ssr.sales_receipt_id AS transaction_id
        ,ssr.account_id AS account_id
        ,ssr.customer_id AS customer_id
        ,'0' AS vendor_id
        ,ssr.class_id AS class_id
        ,'0' AS terms_id
        ,ssr.transaction_date AS transaction_date
        ,ssr.due_date AS due_date
        ,ssr.ship_date AS ship_date
        ,ssr.transaction_number AS transaction_number
        ,ssr.reference_number AS reference_number
        ,CONCAT_WS('', 'SR',ssr.transaction_number) AS type_based_transaction_number
        ,ssr.is_pending AS is_pending
        ,NULL AS is_paid
        ,ssr.is_to_be_printed AS is_to_be_printed
        ,ssr.is_to_be_emailed AS is_to_be_emailed
        ,'Sales Receipt' AS transaction_type
        ,ssr.total_amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,ssr.created_datetime AS created_datetime
        ,ssr.last_modified_datetime AS last_modified_datetime
        ,ssr.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_receipt AS ssr
    UNION ALL
    SELECT
        sstpc.sales_tax_payment_check_id AS transaction_id
        ,sstpc.account_id AS account_id
        ,'0' AS customer_id
        ,sstpc.vendor_id AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,sstpc.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,sstpc.transaction_number AS transaction_number
        ,sstpc.reference_number AS reference_number
        ,CONCAT_WS('', 'STP',sstpc.transaction_number) AS type_based_transaction_number
        ,NULL AS is_pending
        ,NULL AS is_paid
        ,sstpc.is_to_be_printed AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Sales Tax Payment' AS transaction_type
        ,sstpc.total_amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,sstpc.created_datetime AS created_datetime
        ,sstpc.last_modified_datetime AS last_modified_datetime
        ,sstpc.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_payment_check AS sstpc
    UNION ALL
    SELECT
        sir.item_receipt_id AS transaction_id
        ,sir.account_id AS account_id
        ,'0' AS customer_id
        ,sir.vendor_id AS vendor_id
        ,'0' AS class_id
        ,'0' AS terms_id
        ,sir.transaction_date AS transaction_date
        ,NULL AS due_date
        ,NULL AS ship_date
        ,sir.transaction_number AS transaction_number
        ,NULL AS reference_number
        ,CONCAT_WS('', 'IR',sir.transaction_number) AS type_based_transaction_number
        ,NULL AS is_pending
        ,NULL AS is_paid
        ,NULL AS is_to_be_printed
        ,NULL AS is_to_be_emailed
        ,'Item Receipt' AS transaction_type
        ,sir.total_amount AS amount
        ,NULL AS amount_open
        ,NULL AS amount_due
        ,sir.created_datetime AS created_datetime
        ,sir.last_modified_datetime AS last_modified_datetime
        ,sir.load_datetime AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_receipt AS sir
    )
SELECT *
FROM general_ledger AS sgl
-- <Incremental> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.general_ledger As tgl
    ON sgl.transaction_id = tgl.transaction_id
        AND sgl.transaction_type = tgl.transaction_type
WHERE (
    tgl.transaction_id IS NULL
    OR sgl.last_modified_datetime >= '{WATERMARK_DATE}'
    )