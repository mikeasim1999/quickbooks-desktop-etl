SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.invoice_includelineitems as iili
-- << INCREMENTAL >> --
WHERE
    CAST(iili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records

