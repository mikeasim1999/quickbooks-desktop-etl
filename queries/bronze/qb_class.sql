SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.class as c
-- << INCREMENTAL >> --
WHERE
    CAST(c.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records