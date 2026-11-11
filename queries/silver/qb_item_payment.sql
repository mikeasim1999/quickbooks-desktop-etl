WITH source AS (
    SELECT
        sip.ListID AS item_payment_id
        ,CASE WHEN sip.DepositToAccountRef_ListID = '' THEN '0' ELSE sip.DepositToAccountRef_ListID END AS account_id
        ,CASE WHEN sip.PaymentMethodRef_ListID = '' THEN '0' ELSE sip.PaymentMethodRef_ListID END AS payment_method_id

        ,sip.Name AS item_payment_name
        ,sip.FullName AS item_payment_full_name

        ,CAST(sip.IsActive AS BOOLEAN) AS is_active

        ,CASE WHEN sip.DepositToAccountRef_FullName = '' THEN 'Unassigned' ELSE sip.DepositToAccountRef_FullName END AS account_full_name
        ,CASE WHEN sip.PaymentMethodRef_FullName = '' THEN 'Unassigned' ELSE sip.PaymentMethodRef_FullName END AS payment_method_full_name

        ,NULLIF(sip.EditSequence, '') AS edit_sequence
        ,CAST(sip.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sip.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sip.LoadDatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_item_payment AS sip

    UNION ALL

    SELECT
        '0', '0', '0',
        'Unassigned', 'Unassigned',
        TRUE,
        'Unassigned', 'Unassigned',
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
    src.last_modified_datetime >= '{WATERMARK_DATE}'