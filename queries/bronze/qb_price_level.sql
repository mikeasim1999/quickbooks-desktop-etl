SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.pricelevel as pl
-- << INCREMENTAL >> --
WHERE
    CAST(pl.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records