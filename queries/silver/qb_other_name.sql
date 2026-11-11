WITH source AS (
    SELECT
        son.ListID AS other_name_id

        ,son.Name AS other_name

        ,CAST(son.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(son.OtherNameAddress_Addr1, '') AS address
        ,NULLIF(son.OtherNameAddressBlock_Addr1, '') AS address_block

        ,NULLIF(son.EditSequence, '') AS edit_sequence
        ,CAST(son.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(son.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(son.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_other_name AS son

    UNION ALL

    SELECT
        '0', 'Unassigned',
        TRUE,
        NULL, NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'
  