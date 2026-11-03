SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.deposit as d
-- << INCREMENTAL >> --
WHERE
    CAST(d.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records