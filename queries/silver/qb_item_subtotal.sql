WITH source AS (
    SELECT
        sis.ListID AS item_subtotal_id

        ,sis.Name AS item_subtotal_name
        ,sis.FullName AS item_subtotal_full_name
        ,NULLIF(sis.ItemDesc, '') AS item_description

        ,CAST(sis.IsActive AS BOOLEAN) AS is_active
        ,NULLIF(sis.SpecialItemType, '') AS special_item_type

        ,NULLIF(sis.EditSequence, '') AS edit_sequence
        ,CAST(sis.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sis.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sis.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_subtotal AS sis

    UNION ALL

    SELECT
        '0',
        'Unassigned', 'Unassigned', NULL,
        TRUE, NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'