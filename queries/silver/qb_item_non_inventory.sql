WITH source AS (
    SELECT
        sini.ListID AS item_non_inventory_id
        ,CASE WHEN sini.SalesAndPurchase_IncomeAccountRef_ListID = '' THEN '0' ELSE sini.SalesAndPurchase_IncomeAccountRef_ListID END AS income_account_id
        ,CASE WHEN sini.SalesAndPurchase_ExpenseAccountRef_ListID = '' THEN '0' ELSE sini.SalesAndPurchase_ExpenseAccountRef_ListID END AS expense_account_id
        ,CASE WHEN sini.SalesAndPurchase_PrefVendorRef_ListID = '' THEN '0' ELSE sini.SalesAndPurchase_PrefVendorRef_ListID END AS vendor_id
        ,CASE WHEN sini.SalesTaxCodeRef_ListID = '' THEN '0' ELSE sini.SalesTaxCodeRef_ListID END AS sales_tax_code_id

        ,sini.Name AS item_non_inventory_name
        ,sini.FullName AS item_non_inventory_full_name

        ,CAST(sini.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(sini.SalesAndPurchase_SalesDesc, '') AS sales_description
        ,NULLIF(sini.SalesAndPurchase_PurchaseDesc, '') AS purchase_description

        ,CAST(sini.Sublevel AS INT) AS sublevel

        ,CASE WHEN sini.SalesAndPurchase_IncomeAccountRef_FullName = '' THEN 'Unassigned' ELSE sini.SalesAndPurchase_IncomeAccountRef_FullName END AS income_account_full_name
        ,CASE WHEN sini.SalesAndPurchase_ExpenseAccountRef_FullName = '' THEN 'Unassigned' ELSE sini.SalesAndPurchase_ExpenseAccountRef_FullName END AS expense_account_full_name
        ,CASE WHEN sini.SalesAndPurchase_PrefVendorRef_FullName = '' THEN 'Unassigned' ELSE sini.SalesAndPurchase_PrefVendorRef_FullName END AS vendor_full_name
        ,CASE WHEN sini.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sini.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name

        ,CASE WHEN sini.SalesAndPurchase_SalesPrice = '' THEN 0 ELSE CAST(sini.SalesAndPurchase_SalesPrice AS DECIMAL(12, 4)) END AS price
        ,CASE WHEN sini.SalesAndPurchase_PurchaseCost = '' THEN 0 ELSE CAST(sini.SalesAndPurchase_PurchaseCost AS DECIMAL(12, 4)) END AS cost

        ,NULLIF(sini.EditSequence, '') AS edit_sequence
        ,CAST(sini.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sini.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sini.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_non_inventory AS sini

    UNION ALL

    SELECT
        '0', '0', '0', '0', '0',
        'Unassigned', 'Unassigned',
        TRUE,
        NULL, NULL,
        0,
        'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned',
        CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)),
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'