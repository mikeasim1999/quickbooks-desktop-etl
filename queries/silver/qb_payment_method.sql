WITH source AS (
    SELECT
        spm.ListID AS payment_method_id
        
        ,spm.Name AS payment_method_name

        ,CAST(spm.IsActive AS BOOLEAN) AS is_active

        ,NULLIF(spm.PaymentMethodType, '') AS payment_method_type

        ,NULLIF(spm.EditSequence, '') AS edit_sequence
        ,CAST(spm.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(spm.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(spm.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_payment_method AS spm

    UNION ALL

    SELECT
        '0', 'Unassigned',
        TRUE,
        NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_payment_method AS tpm
    ON src.payment_method_id = tpm.payment_method_id
WHERE
  (
    tpm.payment_method_id IS NULL
    OR src.last_modified_datetime >= '{WATERMARK_DATE}'
  )