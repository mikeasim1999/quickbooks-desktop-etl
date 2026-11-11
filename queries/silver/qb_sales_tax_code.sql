WITH source AS (
    SELECT
        sstc.ListID AS sales_tax_code_id

        ,sstc.Name AS sales_tax_code_name
        ,NULLIF(sstc.Desc, '') AS sales_tax_code_description

        ,CAST(sstc.IsActive AS BOOLEAN) AS is_active
        ,CAST(sstc.IsTaxable AS BOOLEAN) AS is_taxable

        ,NULLIF(sstc.EditSequence, '') AS edit_sequence
        ,CAST(sstc.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sstc.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sstc.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_sales_tax_code AS sstc

    UNION ALL

    SELECT
        '0', 'Unassigned', NULL,
        TRUE, FALSE,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'
  