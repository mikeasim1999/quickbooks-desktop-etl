SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.bill_includelineitems as bili
-- << INCREMENTAL >> --
WHERE
    CAST(bili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records

