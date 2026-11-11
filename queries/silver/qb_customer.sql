WITH source AS (
    SELECT
        sc.ListID AS customer_id
        ,CASE WHEN sc.CustomerTypeRef_ListID = '' THEN '0' ELSE sc.CustomerTypeRef_ListID END AS customer_type_id
        ,CASE WHEN sc.TermsRef_ListID = '' THEN '0' ELSE sc.TermsRef_ListID END AS terms_id
        ,CASE WHEN sc.SalesTaxCodeRef_ListID = '' THEN '0' ELSE sc.SalesTaxCodeRef_ListID END AS sales_tax_code_id
        ,CASE WHEN sc.ItemSalesTaxRef_ListID = '' THEN '0' ELSE sc.ItemSalesTaxRef_ListID END AS item_sales_tax_code_id

        ,TRY_CAST(sc.JobStartDate AS DATE) AS job_start_date
        ,TRY_CAST(sc.JobProjectedEndDate AS DATE) AS job_projected_end_date
        ,TRY_CAST(sc.JobEndDate AS DATE) AS job_end_date

        ,sc.Name AS customer_name
        ,sc.FullName AS customer_full_name
        ,SUBSTRING_INDEX(sc.FullName, ':', 1) AS customer_parent_name
        ,NULLIF(sc.Salutation, '') AS salutation
        ,NULLIF(sc.FirstName, '') AS first_name
        ,NULLIF(sc.LastName, '') AS last_name
        ,NULLIF(sc.Phone, '') AS phone
        ,NULLIF(sc.Email, '') AS email
        ,NULLIF(sc.JobStatus, '') AS job_status
        ,NULLIF(sc.Notes, '') AS notes

        ,CAST(sc.Sublevel AS INT) AS sublevel
        ,CAST(sc.IsActive AS BOOLEAN) AS is_active

        ,CASE WHEN sc.CustomerTypeRef_FullName = '' THEN 'Unassigned' ELSE sc.CustomerTypeRef_FullName END AS customer_type
        ,CASE WHEN sc.TermsRef_FullName = '' THEN 'Unassigned' ELSE sc.TermsRef_FullName END AS terms_full_name
        ,CASE WHEN sc.SalesTaxCodeRef_FullName = '' THEN 'Unassigned' ELSE sc.SalesTaxCodeRef_FullName END AS sales_tax_code_full_name
        ,CASE WHEN sc.ItemSalesTaxRef_FullName = '' THEN 'Unassigned' ELSE sc.ItemSalesTaxRef_FullName END AS item_sales_tax_code_full_name

        ,NULLIF(sc.BillAddress_Addr1, '') AS billing_address_1
        ,NULLIF(sc.BillAddress_Addr2, '') AS billing_address_2
        ,NULLIF(sc.BillAddress_City, '') AS billing_city
        ,NULLIF(sc.BillAddress_State, '') AS billing_state
        ,NULLIF(sc.BillAddress_PostalCode, '') AS billing_postal_code
        ,NULLIF(sc.BillAddressBlock_Addr1, '') AS billing_block_address_1
        ,NULLIF(sc.BillAddressBlock_Addr2, '') AS billing_block_address_2
        ,NULLIF(sc.BillAddressBlock_Addr3, '') AS billing_block_address_3

        ,NULLIF(sc.ShipAddress_Addr1, '') AS shipping_address_1
        ,NULLIF(sc.ShipAddress_Addr2, '') AS shipping_address_2
        ,NULLIF(sc.ShipAddress_City, '') AS shipping_city
        ,NULLIF(sc.ShipAddress_State, '') AS shipping_state
        ,NULLIF(sc.ShipAddress_PostalCode, '') AS shipping_postal_code
        ,NULLIF(sc.ShipAddressBlock_Addr1, '') AS shipping_block_address_1
        ,NULLIF(sc.ShipAddressBlock_Addr2, '') AS shipping_block_address_2
        ,NULLIF(sc.ShipAddressBlock_Addr3, '') AS shipping_block_address_3

        ,NULLIF(sc.AccountNumber, '') AS account_number
        
        ,CAST(sc.Balance AS DECIMAL(12,4)) AS balance
        ,CAST(sc.TotalBalance AS DECIMAL(12,4)) AS total_balance

        ,NULLIF(sc.EditSequence, '') AS edit_sequence
        ,CAST(sc.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(sc.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(sc.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_customer AS sc

    UNION ALL

    SELECT
        '0', '0', '0', '0', '0',
        NULL, NULL, NULL,
        'Unassigned', 'Unassigned', 'Unassigned',
        NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        0, TRUE,
        'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned',
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL,
        CAST(0 AS DECIMAL(12,4)), CAST(0 AS DECIMAL(12,4)),
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'
  