WITH source AS (
    SELECT
        sioc.ListID AS item_other_charge_id
        ,CASE WHEN sioc.SalesOrPurchase_AccountRef_ListID = '' THEN '0' ELSE sioc.SalesOrPurchase_AccountRef_ListID END AS account_id
        ,CASE WHEN sioc.SalesTaxCodeRef_ListID = '' THEN '0' ELSE sioc.SalesTaxCodeRef_ListID END AS sales_tax_code_id

        ,sioc.Name AS item_other_charge_name
        ,sioc.FullName AS item_other_charge_full_name

        ,CAST(sioc.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(sioc.SalesOrPurchase_Desc, '') AS description

        ,CAST(sioc.Sublevel AS INT) AS sublevel

        ,CASE WHEN sioc.SalesOrPurchase_AccountRef_FullName = '' THEN 'Unassigned' ELSE sioc.SalesOrPurchase_AccountRef_FullName END AS account_full_name
        ,CASE WHEN sioc.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sioc.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name

        ,CASE WHEN sioc.SalesOrPurchase_Price = '' THEN 0 ELSE CAST(sioc.SalesOrPurchase_Price AS DECIMAL(12, 4)) END AS price

        ,NULLIF(sioc.EditSequence, '') AS edit_sequence
        ,CAST(sioc.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sioc.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sioc.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_other_charge AS sioc

    UNION ALL

    SELECT
        '0', '0', '0',
        'Unassigned', 'Unassigned',
        TRUE,
        NULL,
        0,
        'Unassigned', 'Unassigned',
        CAST(0 AS DECIMAL(12, 4)),
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'