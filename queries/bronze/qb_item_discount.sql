SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemdiscount as id
-- << INCREMENTAL >> --
WHERE
    CAST(id.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records