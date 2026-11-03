SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.employee as e
-- << INCREMENTAL >> --
WHERE
    CAST(e.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records