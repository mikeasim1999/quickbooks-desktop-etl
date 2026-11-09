SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.inventoryadjustment_includelineitems as iaili
-- << INCREMENTAL >> --
WHERE
    CAST(iaili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records