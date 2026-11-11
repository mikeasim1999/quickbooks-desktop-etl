WITH source AS (
    SELECT
        sii.ListID AS item_inventory_id
        ,CASE WHEN sii.IncomeAccountRef_ListID = '' THEN '0' ELSE sii.IncomeAccountRef_ListID END AS income_account_id
        ,CASE WHEN sii.COGSAccountRef_ListID = '' THEN '0' ELSE sii.COGSAccountRef_ListID END AS cogs_account_id
        ,CASE WHEN sii.AssetAccountRef_ListID = '' THEN '0' ELSE sii.AssetAccountRef_ListID END AS asset_account_id
        ,CASE WHEN sii.PrefVendorRef_ListID = '' THEN '0' ELSE sii.PrefVendorRef_ListID END AS vendor_id
        ,CASE WHEN sii.SalesTaxCodeRef_ListID = '' THEN '0' ELSE sii.SalesTaxCodeRef_ListID END AS sales_tax_code_id

        ,sii.Name AS item_inventory_name
        ,sii.FullName AS item_inventory_full_name

        ,NULLIF(sii.SalesDesc, '') AS sales_description
        ,NULLIF(sii.PurchaseDesc, '') AS purchase_description

        ,CAST(sii.IsActive AS BOOLEAN) AS is_active
        ,CAST(sii.Sublevel AS INT) AS sublevel

        ,CASE WHEN sii.IncomeAccountRef_FullName = '' THEN 'Unassigned' ELSE sii.IncomeAccountRef_FullName END AS income_account_full_name
        ,CASE WHEN sii.COGSAccountRef_FullName = '' THEN 'Unassigned' ELSE sii.COGSAccountRef_FullName END AS cogs_account_full_name
        ,CASE WHEN sii.AssetAccountRef_FullName = '' THEN 'Unassigned' ELSE sii.AssetAccountRef_FullName END AS asset_account_full_name
        ,CASE WHEN sii.PrefVendorRef_FullName = '' THEN 'Unassigned' ELSE sii.PrefVendorRef_FullName END AS vendor_full_name
        ,CASE WHEN sii.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sii.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name

        ,CASE WHEN sii.ReorderPoint = '' THEN 0 ELSE CAST(sii.ReorderPoint AS DECIMAL(12, 4)) END AS reorder_point
        ,CASE WHEN sii.QuantityOnHand = '' THEN 0 ELSE CAST(sii.QuantityOnHand AS DECIMAL(12, 4)) END AS quantity_on_hand
        ,CASE WHEN sii.QuantityOnHand = '' OR sii.QuantityOnSalesOrder = '' THEN 0
            ELSE CAST(sii.QuantityOnHand AS DECIMAL(12, 4)) - CAST(sii.QuantityOnSalesOrder AS DECIMAL(12, 4))
        END AS quantity_available_for_sale
        ,CASE WHEN sii.QuantityOnOrder = '' THEN 0 ELSE CAST(sii.QuantityOnOrder AS DECIMAL(12, 4)) END AS quantity_on_order
        ,CASE WHEN sii.QuantityOnSalesOrder = '' THEN 0 ELSE CAST(sii.QuantityOnSalesOrder AS DECIMAL(12, 4)) END AS quantity_on_sales_order
        ,CASE WHEN sii.AverageCost = '' THEN 0 ELSE CAST(sii.AverageCost AS DECIMAL(12, 4)) END AS average_cost
        ,CASE WHEN sii.AverageCost = '' OR sii.QuantityOnHand = '' THEN 0
            ELSE CAST(sii.AverageCost AS DECIMAL(12, 4)) * CAST(sii.QuantityOnHand AS DECIMAL(12, 4))
        END AS on_hand_value

        ,CASE WHEN sii.PurchaseCost = '' THEN 0 ELSE CAST(sii.PurchaseCost AS DECIMAL(12, 4)) END AS cost
        ,CASE WHEN sii.SalesPrice = '' THEN 0 ELSE CAST(sii.SalesPrice AS DECIMAL(12, 4)) END AS price

        ,NULLIF(sii.EditSequence, '') AS edit_sequence
        ,CAST(sii.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sii.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sii.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_inventory AS sii

    UNION ALL

    SELECT
        '0', '0', '0', '0', '0', '0',
        'Unassigned', 'Unassigned',
        NULL, NULL,
        TRUE, 0,
        'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned',
        CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)),
        CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)),
        CAST(0 AS DECIMAL(12, 4)), CAST(0 AS DECIMAL(12, 4)),
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'