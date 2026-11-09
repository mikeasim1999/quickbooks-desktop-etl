SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.purchaseorder_includelineitems as poili
-- << INCREMENTAL >> --
WHERE
    CAST(poili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records