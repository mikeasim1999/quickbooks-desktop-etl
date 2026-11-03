SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.unitofmeasureset as ums
-- << INCREMENTAL >> --
WHERE
    CAST(ums.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records