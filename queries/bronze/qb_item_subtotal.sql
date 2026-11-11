SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemsubtotal as sis
-- << INCREMENTAL >> --
WHERE
    CAST(sis.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records