SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salestaxpaymentcheck_includelineitems as stpcili
-- << INCREMENTAL >> --
WHERE
    CAST(stpcili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records