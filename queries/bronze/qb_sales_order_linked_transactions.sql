SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salesorder_includelinkedtxns as soilt
-- << INCREMENTAL >> --
WHERE
    CAST(soilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records