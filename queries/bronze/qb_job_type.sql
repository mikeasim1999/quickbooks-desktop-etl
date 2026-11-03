SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.jobtype as jt
-- << INCREMENTAL >> --
WHERE
    CAST(jt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records