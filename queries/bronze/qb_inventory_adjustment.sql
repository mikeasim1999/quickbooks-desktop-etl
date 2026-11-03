SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.inventoryadjustment as ia
-- << INCREMENTAL >> --
WHERE
    CAST(ia.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records