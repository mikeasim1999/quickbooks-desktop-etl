SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.bill_includelinkedtxns as bilt
-- << INCREMENTAL >> --
WHERE
    CAST(bilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records