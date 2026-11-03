SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salesorder as so
-- << INCREMENTAL >> --
WHERE
    CAST(so.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records