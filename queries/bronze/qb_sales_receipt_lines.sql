SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salesreceipt_includelineitems as srili
-- << INCREMENTAL >> --
WHERE
    CAST(srili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records