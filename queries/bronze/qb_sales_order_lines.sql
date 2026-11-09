SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salesorder_includelineitems as soili
-- << INCREMENTAL >> --
WHERE
    CAST(soili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records