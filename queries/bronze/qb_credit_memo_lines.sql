SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.creditmemo_includelineitems as cmili
-- << INCREMENTAL >> --
WHERE
    CAST(cmili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records