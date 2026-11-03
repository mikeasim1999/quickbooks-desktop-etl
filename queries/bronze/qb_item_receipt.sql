SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemreceipt as ir
-- << INCREMENTAL >> --
WHERE
    CAST(ir.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records