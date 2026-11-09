SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.estimate_includelineitems as eili
-- << INCREMENTAL >> --
WHERE
    CAST(eili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records