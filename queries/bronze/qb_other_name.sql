SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.othername as ona
-- << INCREMENTAL >> --
WHERE
    CAST(ona.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records