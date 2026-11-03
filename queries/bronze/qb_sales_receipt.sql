SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salesreceipt as sr
-- << INCREMENTAL >> --
WHERE
    CAST(sr.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records