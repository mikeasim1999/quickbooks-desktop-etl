SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemothercharge as ioc
-- << INCREMENTAL >> --
WHERE
    CAST(ioc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records