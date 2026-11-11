SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemgroup as ig
-- << INCREMENTAL >> --
WHERE
    CAST(ig.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records