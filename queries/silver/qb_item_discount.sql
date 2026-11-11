WITH source AS (
    SELECT
        sid.ListID AS item_discount_id
        ,CASE WHEN sid.SalesTaxCodeRef_ListID = '' THEN '0' ELSE sid.SalesTaxCodeRef_ListID END AS sales_tax_code_id
        ,CASE WHEN sid.AccountRef_ListID = '' THEN '0' ELSE sid.AccountRef_ListID END AS account_id

        ,sid.Name AS item_discount_name
        ,sid.FullName AS item_discount_full_name
        ,NULLIF(sid.ItemDesc, '') AS item_description

        ,CAST(sid.IsActive AS BOOLEAN) AS is_active
        ,CAST(sid.Sublevel AS INT) AS sublevel

        ,CASE WHEN sid.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sid.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name
        ,CASE WHEN sid.AccountRef_FullName = '' THEN 'Unassigned' ELSE sid.AccountRef_FullName END AS account_full_name

        ,CASE WHEN sid.DiscountRatePercent = '' THEN 0 ELSE CAST(sid.DiscountRatePercent AS DECIMAL(12, 4)) END AS discount_rate_percent

        ,NULLIF(sid.EditSequence, '') AS edit_sequence
        ,CAST(sid.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sid.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sid.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_discount AS sid

    UNION ALL

    SELECT
        '0', '0', '0',
        'Unassigned', 'Unassigned', NULL,
        TRUE, 0,
        'Unassigned', 'Unassigned',
        CAST(0 AS DECIMAL(12, 4)),
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'