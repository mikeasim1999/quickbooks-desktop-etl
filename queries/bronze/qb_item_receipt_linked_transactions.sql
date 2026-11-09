SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemreceipt_includelinkedtxns as irilt
-- << INCREMENTAL >> --
WHERE
    CAST(irilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records