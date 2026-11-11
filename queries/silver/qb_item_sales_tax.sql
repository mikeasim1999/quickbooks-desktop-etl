WITH source AS (
    SELECT
        sist.ListID AS item_sales_tax_id
        ,CASE WHEN sist.TaxVendorRef_ListID = '' THEN '0' ELSE sist.TaxVendorRef_ListID END AS vendor_id

        ,sist.Name AS item_sales_tax_name
        
        ,NULLIF(sist.ItemDesc, '') AS item_description

        ,CAST(sist.IsActive AS BOOLEAN) AS is_active

        ,CASE WHEN sist.TaxVendorRef_FullName = '' THEN 'Unassigned' ELSE sist.TaxVendorRef_FullName END AS vendor_full_name

        ,CASE WHEN sist.TaxRate = '' THEN 0 ELSE CAST(sist.TaxRate AS DECIMAL(12, 4)) END AS sales_tax_rate

        ,NULLIF(sist.EditSequence, '') AS edit_sequence
        ,CAST(sist.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sist.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sist.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_sales_tax AS sist

    UNION ALL

    SELECT
        '0', 
        '0',
        'Unassigned', 
        NULL,
        TRUE,
        'Unassigned',
        CAST(0 AS DECIMAL(12, 4)),
        NULL, 
        NULL, 
        NULL, 
        NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'