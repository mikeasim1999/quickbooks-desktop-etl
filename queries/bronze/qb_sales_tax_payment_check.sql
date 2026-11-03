SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salestaxpaymentcheck as stpc
-- << INCREMENTAL >> --
WHERE
    CAST(stpc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records