SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.customertype as ct
-- << INCREMENTAL >> --
WHERE
    CAST(ct.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records