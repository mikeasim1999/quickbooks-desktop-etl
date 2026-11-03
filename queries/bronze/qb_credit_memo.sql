SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.creditmemo as cm
-- << INCREMENTAL >> --
WHERE
    CAST(cm.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records