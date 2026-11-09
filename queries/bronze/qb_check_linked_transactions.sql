SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.check_includelinkedtxns as cilt
-- << INCREMENTAL >> --
WHERE
    CAST(cilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records