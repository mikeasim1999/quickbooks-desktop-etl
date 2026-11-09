SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.vendorcredit_includelinkedtxns as vcilt
-- << INCREMENTAL >> --
WHERE
    CAST(vcilt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records