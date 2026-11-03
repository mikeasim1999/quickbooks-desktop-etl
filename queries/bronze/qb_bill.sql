SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.bill as b
-- << INCREMENTAL >> --
WHERE
    CAST(b.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records