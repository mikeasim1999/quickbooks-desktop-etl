SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemreceipt_includelineitems as irili
-- << INCREMENTAL >> --
WHERE
    CAST(irili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records