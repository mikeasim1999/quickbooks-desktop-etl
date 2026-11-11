WITH source AS (
    SELECT
        sifa.ListID AS item_fixed_asset_id
        ,CASE WHEN sifa.AssetAccountRef_ListID = '' THEN '0' ELSE sifa.AssetAccountRef_ListID END AS account_id

        ,CAST(sifa.PurchaseDate AS DATE) AS purchase_date

        ,sifa.Name AS item_fixed_asset_name

        ,CAST(sifa.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(sifa.AcquiredAs, '') AS acquired_as
        ,NULLIF(sifa.PurchaseDesc, '') AS purchase_description
        ,NULLIF(sifa.AssetNumber, '') AS asset_number

        ,CASE WHEN sifa.CostBasis = '' THEN 0 ELSE CAST(sifa.CostBasis AS DECIMAL(12, 4)) END AS cost_basis
        ,CASE WHEN sifa.YearEndAccumulatedDepreciation = '' THEN 0 ELSE CAST(sifa.YearEndAccumulatedDepreciation AS DECIMAL(12, 4)) END AS year_end_accumulated_depreciation
        ,CASE WHEN sifa.PurchaseCost = '' THEN 0 ELSE CAST(sifa.PurchaseCost AS DECIMAL(12, 4)) END AS purchase_cost
        ,CASE WHEN sifa.YearEndBookValue = '' THEN 0 ELSE CAST(sifa.YearEndBookValue AS DECIMAL(12, 4)) END AS year_end_book_value

        ,CASE WHEN sifa.AssetAccountRef_FullName = '' THEN 'Unassigned' ELSE sifa.AssetAccountRef_FullName END AS account_full_name

        ,NULLIF(sifa.EditSequence, '') AS edit_sequence
        ,CAST(sifa.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sifa.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sifa.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_fixed_asset AS sifa

    UNION ALL

    SELECT
        '0', 
        '0',
        NULL,
        'Unassigned', 
        TRUE,
        NULL, 
        NULL, 
        NULL,
        CAST(0 AS DECIMAL(12, 4)), 
        CAST(0 AS DECIMAL(12, 4)), 
        CAST(0 AS DECIMAL(12, 4)), 
        CAST(0 AS DECIMAL(12, 4)),
        'Unassigned',
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