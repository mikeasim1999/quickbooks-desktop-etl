WITH source AS (
    SELECT
        sig.ListID AS item_group_id
        ,CASE WHEN sig.ItemGroupLine_ItemRef_ListID = '' THEN '0' ELSE sig.ItemGroupLine_ItemRef_ListID END AS item_id

        ,sig.Name AS item_group_name
        ,sig.FullName AS item_group_full_name

        ,CAST(sig.IsActive AS BOOLEAN) AS is_active
        ,CASE WHEN sig.IsPrintItemsInGroup = '' THEN FALSE ELSE CAST(sig.IsPrintItemsInGroup AS BOOLEAN) END AS is_print_items_in_group

        ,NULLIF(sig.ItemGroupLine_UnitOfMeasure, '') AS unit_of_measure

        ,CASE WHEN sig.ItemGroupLine_ItemRef_FullName = '' THEN 'Unassigned' ELSE sig.ItemGroupLine_ItemRef_FullName END AS item_full_name

        ,CASE WHEN sig.ItemGroupLine_Quantity = '' THEN 0 ELSE CAST(sig.ItemGroupLine_Quantity AS DECIMAL(12, 4)) END AS quantity

        ,NULLIF(sig.EditSequence, '') AS edit_sequence
        ,CAST(sig.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sig.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sig.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_group AS sig

    UNION ALL

    SELECT
        '0', 
        '0',
        'Unassigned', 
        'Unassigned',
        TRUE, 
        FALSE,
        NULL,
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