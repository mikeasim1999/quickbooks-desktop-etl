SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.vendor as v
-- << INCREMENTAL >> --
WHERE
    CAST(v.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records