SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.invoice as i
-- << INCREMENTAL >> --
WHERE
    CAST(i.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records