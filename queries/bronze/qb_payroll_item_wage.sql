SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.payrollitemwage as piw
-- << INCREMENTAL >> --
WHERE
    CAST(piw.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records