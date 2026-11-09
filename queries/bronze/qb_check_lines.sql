SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.check_includelineitems as cili
-- << INCREMENTAL >> --
WHERE
    CAST(cili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records