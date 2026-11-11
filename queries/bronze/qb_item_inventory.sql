SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.iteminventory as ii
-- << INCREMENTAL >> --
WHERE
    CAST(ii.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records