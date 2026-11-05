-- =============================================================================
-- General Ledger
-- Gold Layer — Union of all posting transaction tables from Silver
-- Sign Convention: Positive = Debit, Negative = Credit
-- =============================================================================
-- Excludes non-posting transactions (Estimates, Sales Orders) and
-- non-monetary entries (Time Tracking, Inventory Adjustments without amounts).
-- Journal Entries are excluded as the Silver table has headers only (no amounts).
--
-- Bill Payment Checks produce TWO rows: a debit to AP and a credit to Bank.
-- All other transactions produce one row referencing their primary account.
-- =============================================================================

-- Invoice: Debit AR (asset increases)
SELECT
    invoice_id                  AS transaction_id
    ,'Invoice'                  AS transaction_type
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,account_id                 -- AR Account
    ,customer_id
    ,CAST(NULL AS STRING)       AS vendor_id
    ,class_id
    ,subtotal_amount            AS amount
    ,CAST(NULL AS STRING)       AS memo
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_invoice
WHERE subtotal_amount IS NOT NULL

UNION ALL

-- Sales Receipt: Debit Bank (cash sale, asset increases)
SELECT
    sales_receipt_id
    ,'Sales Receipt'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,account_id                 -- Deposit-to Bank Account
    ,customer_id
    ,CAST(NULL AS STRING)
    ,class_id
    ,total_amount
    ,CAST(NULL AS STRING)
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_sales_receipt
WHERE total_amount IS NOT NULL

UNION ALL

-- Deposit: Debit Bank (asset increases)
SELECT
    deposit_id
    ,'Deposit'
    ,transaction_date
    ,transaction_number
    ,CAST(NULL AS STRING)       -- no reference_number
    ,account_id                 -- Bank Account
    ,CAST(NULL AS STRING)
    ,CAST(NULL AS STRING)
    ,CAST(NULL AS STRING)
    ,deposit_amount
    ,memo
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_deposit
WHERE deposit_amount IS NOT NULL

UNION ALL

-- Bill: Credit AP (liability increases)
SELECT
    bill_id
    ,'Bill'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,account_id                 -- AP Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,amount_due * -1            -- credit: liability increases
    ,CAST(NULL AS STRING)
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_bill
WHERE amount_due IS NOT NULL

UNION ALL

-- Check: Credit Bank (asset decreases)
SELECT
    check_id
    ,'Check'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,account_id                 -- Bank Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,amount * -1                -- credit: cash outflow
    ,CAST(NULL AS STRING)
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_check
WHERE amount IS NOT NULL

UNION ALL

-- Credit Card Charge: Credit CC Liability (liability increases)
SELECT
    credit_card_charge_id
    ,'Credit Card Charge'
    ,transaction_date
    ,transaction_number
    ,CAST(NULL AS STRING)
    ,account_id                 -- Credit Card Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,amount * -1                -- credit: liability increases
    ,CAST(NULL AS STRING)
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_credit_card_charge
WHERE amount IS NOT NULL

UNION ALL

-- Credit Memo: Credit AR (asset decreases, reverses revenue)
SELECT
    credit_memo_id
    ,'Credit Memo'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,account_id                 -- AR Account
    ,customer_id
    ,CAST(NULL AS STRING)
    ,class_id
    ,total_amount * -1          -- credit: reduces receivables
    ,CAST(NULL AS STRING)
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_credit_memo
WHERE total_amount IS NOT NULL

UNION ALL

-- Vendor Credit: Debit AP (liability decreases, reduces payables)
SELECT
    vendor_credit_id
    ,'Vendor Credit'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,account_id                 -- AP Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,credit_amount              -- debit: reduces AP liability
    ,CAST(NULL AS STRING)
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_vendor_credit
WHERE credit_amount IS NOT NULL

UNION ALL

-- Item Receipt: Credit AP (liability increases, goods received)
SELECT
    item_receipt_id
    ,'Item Receipt'
    ,transaction_date
    ,transaction_number
    ,CAST(NULL AS STRING)
    ,account_id                 -- AP Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,total_amount * -1          -- credit: liability increases
    ,memo
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_item_receipt
WHERE total_amount IS NOT NULL

UNION ALL

-- Bill Payment Check — AP side: Debit AP (liability decreases)
SELECT
    bill_payment_check_id
    ,'Bill Payment'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,ap_account_id              AS account_id  -- AP Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,amount                     -- debit: reduces AP liability
    ,memo
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_bill_payment_check
WHERE amount IS NOT NULL

UNION ALL

-- Bill Payment Check — Bank side: Credit Bank (asset decreases)
SELECT
    bill_payment_check_id
    ,'Bill Payment'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,bank_account_id            AS account_id  -- Bank Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,amount * -1                -- credit: cash outflow
    ,memo
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_bill_payment_check
WHERE amount IS NOT NULL

UNION ALL

-- Sales Tax Payment Check: Credit Bank (asset decreases)
SELECT
    sales_tax_payment_check_id
    ,'Sales Tax Payment'
    ,transaction_date
    ,transaction_number
    ,reference_number
    ,account_id                 -- Bank Account
    ,CAST(NULL AS STRING)
    ,vendor_id
    ,CAST(NULL AS STRING)
    ,total_amount * -1          -- credit: cash outflow
    ,memo
    ,created_datetime
    ,last_modified_datetime
    ,load_datetime
FROM {CATALOG}.silver.qb_sales_tax_payment_check
WHERE total_amount IS NOT NULL
