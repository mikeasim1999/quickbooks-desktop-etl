WITH source AS (
    SELECT
        sis.ListID AS item_service_id
        ,CASE WHEN sis.SalesOrPurchase_AccountRef_ListID = '' THEN '0' ELSE sis.SalesOrPurchase_AccountRef_ListID END AS account_id
        ,CASE WHEN sis.SalesTaxCodeRef_ListID = '' THEN '0' ELSE sis.SalesTaxCodeRef_ListID END AS sales_tax_code_id

        ,sis.Name AS item_service_name
        ,sis.FullName AS item_service_full_name

        ,CAST(sis.IsActive AS BOOLEAN) AS is_active

        ,CAST(sis.Sublevel AS INT) AS sublevel

        ,CASE WHEN sis.SalesOrPurchase_AccountRef_FullName = '' THEN 'Unassigned' ELSE sis.SalesOrPurchase_AccountRef_FullName END AS account_full_name
        ,CASE WHEN sis.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sis.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name

        ,CASE WHEN sis.SalesOrPurchase_Price = '' THEN 0 ELSE CAST(sis.SalesOrPurchase_Price AS DECIMAL(12, 4)) END AS price

        ,NULLIF(sis.EditSequence, '') AS edit_sequence
        ,CAST(sis.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sis.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sis.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_service AS sis

    UNION ALL

    SELECT
        '0', '0', '0',
        'Unassigned', 'Unassigned',
        TRUE,
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