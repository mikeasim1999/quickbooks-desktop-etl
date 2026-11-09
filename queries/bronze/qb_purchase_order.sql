SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.purchaseorder as po
-- << INCREMENTAL >> --
WHERE
    CAST(po.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records