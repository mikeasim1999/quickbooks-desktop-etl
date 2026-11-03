SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.payrollitemnonwage as pin
-- << INCREMENTAL >> --
WHERE
    CAST(pin.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records