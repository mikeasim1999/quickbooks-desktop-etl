WITH source AS (
    SELECT
        sv.ListID AS vendor_id
        ,NULLIF(sv.ContactsRet_ListID, '') AS contact_id

        ,NULLIF(sv.ContactsRet_TimeCreated, '') AS contact_created_datetime
        ,NULLIF(sv.ContactsRet_TimeModified, '') AS contact_last_modified_datetime

        ,sv.Name AS vendor_name
        ,NULLIF(sv.CompanyName, '') AS vendor_company_name
        ,NULLIF(sv.Salutation, '') AS salutation
        ,NULLIF(sv.FirstName, '') AS first_name
        ,NULLIF(sv.LastName, '') AS last_name
        ,NULLIF(sv.Phone, '') AS phone
        ,NULLIF(sv.Fax, '') AS fax
        ,NULLIF(sv.Email, '') AS email
        ,CASE
            WHEN sv.contact IN ('N/A', '') THEN NULL
            ELSE sv.contact
        END AS contact_name
        ,CASE
            WHEN sv.ContactsRet_FirstName IN ('N/A', '') THEN NULL
            ELSE sv.ContactsRet_FirstName
        END AS contact_first_name
        ,CASE
            WHEN UPPER(sv.AdditionalContactRef_ContactName) = 'MAIN EMAIL' THEN sv.AdditionalContactRef_ContactValue
            ELSE NULL
        END AS contact_email
        ,CASE
            WHEN UPPER(sv.AdditionalContactRef_ContactName) = 'MAIN PHONE' THEN sv.AdditionalContactRef_ContactValue
            ELSE NULL
        END AS contact_phone
        ,CASE
            WHEN UPPER(sv.AdditionalContactRef_ContactName) = 'FAX' THEN sv.AdditionalContactRef_ContactValue
            ELSE NULL
        END AS contact_fax
        ,CASE
            WHEN UPPER(sv.AdditionalContactRef_ContactName) = 'CC EMAIL' THEN sv.AdditionalContactRef_ContactValue
            ELSE NULL
        END AS contact_cc_email
        ,CASE
            WHEN UPPER(sv.AdditionalContactRef_ContactName) IN ('ALT PHONE', 'ALT. PHONE') THEN sv.AdditionalContactRef_ContactValue
            ELSE NULL
        END AS contact_alt_phone
        ,NULLIF(sv.NameOnCheck, '') AS name_on_check

        ,CAST(sv.IsActive AS BOOLEAN) AS is_active
        ,CAST(sv.IsVendorEligibleFor1099 AS BOOLEAN) AS is_eligible_for_1099

        ,NULLIF(sv.VendorAddress_Addr1, '') AS address_1
        ,NULLIF(sv.VendorAddress_Addr2, '') AS address_2
        ,NULLIF(sv.VendorAddress_Addr3, '') AS address_3
        ,NULLIF(sv.VendorAddress_City, '') AS city
        ,NULLIF(sv.VendorAddress_State, '') AS state
        ,NULLIF(sv.VendorAddress_PostalCode, '') AS postal_code
        ,NULLIF(sv.VendorAddressBlock_Addr1, '') AS address_block_1
        ,NULLIF(sv.VendorAddressBlock_Addr2, '') AS address_block_2
        ,NULLIF(sv.VendorAddressBlock_Addr3, '') AS address_block_3
        ,NULLIF(sv.VendorAddressBlock_Addr4, '') AS address_block_4
        
        ,CAST(sv.Balance AS DECIMAL(12,4)) AS balance

        ,NULLIF(sv.EditSequence, '') AS edit_sequence
        ,CAST(sv.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sv.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sv.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_vendor AS sv

    UNION ALL

    SELECT
        '0', NULL,
        NULL, NULL,
        'Unassigned', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        TRUE, FALSE,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL,
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
LEFT JOIN {CATALOG}.{TARGET_SCHEMA}.qb_vendor AS tv
    ON src.vendor_id = tv.vendor_id
WHERE
  (
    tv.vendor_id IS NULL
    OR src.last_modified_datetime >= '{WATERMARK_DATE}'
  )