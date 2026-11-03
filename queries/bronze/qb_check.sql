SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.check as c
-- << INCREMENTAL >> --
WHERE
    CAST(c.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records