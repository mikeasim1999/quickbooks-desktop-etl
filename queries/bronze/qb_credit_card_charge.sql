SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.creditcardcharge as ccc
-- << INCREMENTAL >> --
WHERE
    CAST(ccc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records