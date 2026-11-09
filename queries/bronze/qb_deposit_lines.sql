SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.deposit_includelineitems as dili
-- << INCREMENTAL >> --
WHERE
    CAST(dili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records