SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.shipmethod as sm
-- << INCREMENTAL >> --
WHERE
    CAST(sm.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records