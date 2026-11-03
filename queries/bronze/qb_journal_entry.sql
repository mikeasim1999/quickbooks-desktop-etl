SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.journalentry as je
-- << INCREMENTAL >> --
WHERE
    CAST(je.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records