SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.invoice_includelinkedtxns as iilt
-- << INCREMENTAL >> --
WHERE
    CAST(iilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records

