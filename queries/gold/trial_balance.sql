-- =============================================================================
-- Trial Balance
-- Gold Layer — Aggregated from general_ledger joined to chart of accounts
-- =============================================================================
-- Provides period-level account balances for P&L and Balance Sheet reporting.
-- Debits are positive, Credits are negative in the general_ledger source.
--
-- account_classification groups accounts into:
--   'Revenue', 'Cost of Goods Sold', 'Expense', 'Asset', 'Liability', 'Equity'
--
-- For P&L: filter to Revenue + COGS + Expense classifications.
-- For Balance Sheet: filter to Asset + Liability + Equity classifications.
-- =============================================================================

SELECT
    gl.account_id
    ,a.account_name
    ,a.account_full_name
    ,a.account_number
    ,a.account_display_name
    ,a.account_type
    ,a.is_balance_sheet

    ,CASE
        WHEN a.account_type IN ('Income', 'Other Income')
            THEN 'Revenue'
        WHEN a.account_type = 'Cost Of Goods Sold'
            THEN 'Cost of Goods Sold'
        WHEN a.account_type IN ('Expense', 'Other Expense')
            THEN 'Expense'
        WHEN a.account_type IN ('Bank', 'Accounts Receivable', 'Other Current Asset',
                                'Fixed Asset', 'Other Asset')
            THEN 'Asset'
        WHEN a.account_type IN ('Accounts Payable', 'Credit Card',
                                'Other Current Liability', 'Long Term Liability')
            THEN 'Liability'
        WHEN a.account_type = 'Equity'
            THEN 'Equity'
        ELSE 'Other'
    END AS account_classification

    ,YEAR(gl.transaction_date)                          AS fiscal_year
    ,MONTH(gl.transaction_date)                         AS fiscal_month
    ,DATE_TRUNC('MONTH', gl.transaction_date)           AS fiscal_period

    ,COUNT(*)                                           AS transaction_count
    ,SUM(CASE WHEN gl.amount > 0 THEN gl.amount ELSE 0 END)    AS total_debits
    ,SUM(CASE WHEN gl.amount < 0 THEN ABS(gl.amount) ELSE 0 END) AS total_credits
    ,SUM(gl.amount)                                     AS net_amount

FROM {CATALOG}.gold.general_ledger         AS gl
INNER JOIN {CATALOG}.silver.qb_account     AS a
    ON gl.account_id = a.account_id

GROUP BY
    gl.account_id
    ,a.account_name
    ,a.account_full_name
    ,a.account_number
    ,a.account_display_name
    ,a.account_type
    ,a.is_balance_sheet
    ,YEAR(gl.transaction_date)
    ,MONTH(gl.transaction_date)
    ,DATE_TRUNC('MONTH', gl.transaction_date)
