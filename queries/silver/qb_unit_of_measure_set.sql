WITH source AS (
    SELECT
        suom.ListID AS unit_of_measure_set_id

        ,suom.Name AS unit_of_measure_set_name
        ,NULLIF(suom.BaseUnit_Name, '') AS base_unit_name
        ,NULLIF(suom.BaseUnit_Abbreviation, '') AS base_unit_abbreviation
        ,NULLIF(suom.RelatedUnit_Name, '') AS related_unit_name
        ,NULLIF(suom.RelatedUnit_Abbreviation, '') AS related_unit_abbreviation

        ,CAST(suom.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(suom.UnitOfMeasureType, '') AS unit_of_measure_type

        ,suom.RelatedUnit_ConversionRatio AS related_unit_conversion_ratio
        ,NULLIF(suom.DefaultUnit_UnitUsedFor, '') AS default_unit_used_for
        ,NULLIF(suom.DefaultUnit_Unit, '') AS default_unit

        ,NULLIF(suom.EditSequence, '') AS edit_sequence
        ,CAST(suom.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(suom.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(suom.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_unit_of_measure_set AS suom

    UNION ALL

    SELECT
        '0', 'Unassigned',
        NULL, NULL, NULL, NULL,
        TRUE,
        NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'