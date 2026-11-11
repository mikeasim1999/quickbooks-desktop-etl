WITH source AS (
    SELECT
        se.ListID AS employee_id

        ,TRY_CAST(se.HiredDate AS DATE) AS hired_date

        ,se.Name AS employee_full_name
        ,NULLIF(se.FirstName, '') AS employee_first_name
        ,NULLIF(se.MiddleName, '') AS employee_middle_name
        ,NULLIF(se.LastName, '') AS employee_last_name
        ,NULLIF(se.PrintAs, '') AS employee_display_name

        ,NULLIF(se.EmployeeType, '') AS employee_type
        
        ,NULLIF(se.EmployeeAddress_Addr1, '') AS employee_address_street
        ,NULLIF(se.EmployeeAddress_City, '') AS employee_address_city
        ,NULLIF(se.EmployeeAddress_State, '') AS employee_address_state
        ,NULLIF(se.EmployeeAddress_PostalCode, '') AS employee_address_postal_code

        ,NULLIF(se.Phone, '') AS phone

        ,NULLIF(se.AdditionalContactRef_ContactName, '') AS additional_contact_name
        ,NULLIF(se.AdditionalContactRef_ContactValue, '') AS additional_contact_value
        
        ,CAST(se.TargetBonus AS DECIMAL(12,4)) AS target_bonus

        ,NULLIF(se.EditSequence, '') AS edit_sequence
        ,CAST(se.TimeCreated AS TIMESTAMP) AS created_datetime
        ,CAST(se.TimeModified AS TIMESTAMP) AS last_modified_datetime
        ,CAST(se.loaddatetime AS TIMESTAMP) AS load_datetime
    FROM {CATALOG}.{SOURCE_SCHEMA}.qb_employee AS se

    UNION ALL

    SELECT
        '0', NULL,
        'Unassigned', NULL, NULL, NULL, NULL,
        NULL,
        NULL, NULL, NULL, NULL,
        NULL,
        NULL, NULL,
        CAST(0 AS DECIMAL(12,4)),
        NULL, NULL, NULL, NULL
)
SELECT src.*
FROM source AS src
-- << INCREMENTAL >> --
WHERE
  src.last_modified_datetime >= '{WATERMARK_DATE}'
  