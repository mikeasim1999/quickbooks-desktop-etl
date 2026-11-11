SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemservice as sis
-- << INCREMENTAL >> --
WHERE
    CAST(sis.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records