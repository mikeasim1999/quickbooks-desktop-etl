SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.creditmemo_includelinkedtxns as cmilt
-- << INCREMENTAL >> --
WHERE
    CAST(cmilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records