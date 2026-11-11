SELECT
    stt.TxnID AS time_tracking_id
    ,CASE WHEN stt.EntityRef_ListID = '' THEN '0' ELSE stt.EntityRef_ListID END AS employee_id
    ,CASE WHEN stt.CustomerRef_ListID = '' THEN '0' ELSE stt.CustomerRef_ListID END AS customer_id
    ,CASE WHEN stt.ItemServiceRef_ListID = '' THEN '0' ELSE stt.ItemServiceRef_ListID END AS service_id
    ,CASE WHEN stt.PayrollItemWageRef_ListID = '' THEN '0' ELSE stt.PayrollItemWageRef_ListID END AS payroll_item_wage_id

    ,CAST(stt.TxnDate AS DATE) AS transaction_date

    ,CAST(stt.TxnNumber AS INT) AS transaction_number

    ,TRIM(REGEXP_REPLACE(stt.BillableStatus, '([A-Z])', ' $1')) AS billable_status

    ,CASE WHEN stt.EntityRef_FullName = '' THEN 'Unassigned' ELSE stt.EntityRef_FullName END AS employee_full_name
    ,CASE WHEN stt.CustomerRef_FullName = '' THEN 'Unassigned' ELSE stt.CustomerRef_FullName END AS customer_full_name
    ,CASE WHEN stt.ItemServiceRef_FullName = '' THEN 'Unassigned' ELSE stt.ItemServiceRef_FullName END AS service_full_name
    ,CASE WHEN stt.PayrollItemWageRef_FullName = '' THEN 'Unassigned' ELSE stt.PayrollItemWageRef_FullName END AS payroll_full_name

    -- hours
    ,COALESCE(TRY_CAST(REGEXP_EXTRACT(stt.Duration, '(\\d+)H', 1) AS INT), 0) AS duration_hours
    ,COALESCE(TRY_CAST(REGEXP_EXTRACT(stt.Duration, '(\\d+)M', 1) AS INT), 0) AS duration_minutes
    ,COALESCE(TRY_CAST(REGEXP_EXTRACT(stt.Duration, '(\\d+)H', 1) AS INT), 0)
        + COALESCE(TRY_CAST(REGEXP_EXTRACT(stt.Duration, '(\\d+)M', 1) AS INT), 0) / 60.0 AS total_duration

    ,NULLIF(stt.EditSequence, '') AS edit_sequence
    ,CAST(stt.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(stt.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(stt.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_time_tracking AS stt
-- << INCREMENTAL >> --
WHERE
    CAST(stt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  