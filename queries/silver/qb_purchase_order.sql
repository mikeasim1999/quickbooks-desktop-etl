SELECT
    spo.TxnID AS purchase_order_id
    ,CASE WHEN spo.VendorRef_ListID = '' THEN '0' ELSE spo.VendorRef_ListID END AS vendor_id
    ,CASE WHEN spo.ClassRef_ListID = '' THEN '0' ELSE spo.ClassRef_ListID END AS class_id
    ,CASE WHEN spo.ShipToEntityRef_ListID = '' THEN '0' ELSE spo.ShipToEntityRef_ListID END AS ship_to_id
    ,CASE WHEN spo.TemplateRef_ListID = '' THEN '0' ELSE spo.TemplateRef_ListID END AS template_id

    ,CAST(spo.TxnDate AS DATE) AS transaction_date
    ,CAST(spo.DueDate AS DATE) AS due_date
    ,CAST(spo.ExpectedDate AS DATE) AS expected_date

    ,CAST(spo.TxnNumber AS INT) AS transaction_number
    ,NULLIF(spo.RefNumber, '') AS reference_number

    ,CAST(spo.IsManuallyClosed AS BOOLEAN) AS is_manually_closed
    ,CAST(spo.IsToBePrinted AS BOOLEAN) AS is_to_be_printed
    ,CAST(spo.IsToBeEmailed AS BOOLEAN) AS is_to_be_emailed

    ,NULLIF(spo.Memo, '') AS memo

    ,NULLIF(spo.VendorAddress_Addr1, '') AS vendor_address_1
    ,NULLIF(spo.VendorAddress_Addr2, '') AS vendor_address_2
    ,NULLIF(spo.VendorAddress_Addr3, '') AS vendor_address_3
    ,NULLIF(spo.VendorAddress_City, '') AS vendor_city
    ,NULLIF(spo.VendorAddress_State, '') AS vendor_state
    ,NULLIF(spo.VendorAddressBlock_Addr1, '') AS vendor_address_block_1
    ,NULLIF(spo.VendorAddressBlock_Addr2, '') AS vendor_address_block_2
    ,NULLIF(spo.VendorAddressBlock_Addr3, '') AS vendor_address_block_3
    ,NULLIF(spo.VendorAddressBlock_Addr4, '') AS vendor_address_block_4

    ,NULLIF(spo.ShipAddress_Addr1, '') AS ship_address_1
    ,NULLIF(spo.ShipAddress_Addr2, '') AS ship_address_2
    ,NULLIF(spo.ShipAddress_City, '') AS ship_city
    ,NULLIF(spo.ShipAddress_State, '') AS ship_state
    ,NULLIF(spo.ShipAddress_PostalCode, '') AS ship_postal_code
    ,NULLIF(spo.ShipAddressBlock_Addr1, '') AS ship_address_block_1
    ,NULLIF(spo.ShipAddressBlock_Addr2, '') AS ship_address_block_2
    ,NULLIF(spo.ShipAddressBlock_Addr3, '') AS ship_address_block_3

    ,CASE WHEN spo.VendorRef_FullName = '' THEN 'Unassigned' ELSE spo.VendorRef_FullName END AS vendor_full_name
    ,CASE WHEN spo.ClassRef_FullName = '' THEN 'Unassigned' ELSE spo.ClassRef_FullName END AS class_full_name
    ,CASE WHEN spo.ShipToEntityRef_FullName = '' THEN 'Unassigned' ELSE spo.ShipToEntityRef_FullName END AS ship_to_full_name
    ,CASE WHEN spo.TemplateRef_FullName = '' THEN 'Unassigned' ELSE spo.TemplateRef_FullName END AS template_full_name

    ,CASE WHEN spo.TotalAmount = '' THEN 0 ELSE CAST(spo.TotalAmount AS DECIMAL(12, 4)) END AS total_amount

    ,NULLIF(spo.EditSequence, '') AS edit_sequence
    ,CAST(spo.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(spo.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(spo.loaddatetime AS TIMESTAMP) AS load_datetime
FROM analytics_lakehouse_dev.bronze.qb_purchase_order AS spo
-- << INCREMENTAL >> --
WHERE
    CAST(spo.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'