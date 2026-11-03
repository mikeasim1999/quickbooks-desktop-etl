SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.account as a
-- << INCREMENTAL >> --
WHERE
    CAST(a.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records