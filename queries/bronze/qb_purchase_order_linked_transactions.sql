SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.purchaseorder_includelinkedtxns as poilt
-- << INCREMENTAL >> --
WHERE
    CAST(poilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records