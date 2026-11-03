SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.billpaymentcheck as bpc
-- << INCREMENTAL >> --
WHERE
    CAST(bpc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records