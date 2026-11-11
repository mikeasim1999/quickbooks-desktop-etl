SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemservice as is
-- << INCREMENTAL >> --
WHERE
    CAST(is.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records