SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.billpaymentcheck_includelineitems as bpcili
-- << INCREMENTAL >> --
WHERE
    CAST(bpcili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records