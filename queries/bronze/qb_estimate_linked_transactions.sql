SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.estimate_includelinkedtxns as eilt
-- << INCREMENTAL >> --
WHERE
    CAST(eilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records