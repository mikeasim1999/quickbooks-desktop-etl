SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.vendortype as vt
-- << INCREMENTAL >> --
WHERE
    CAST(vt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records