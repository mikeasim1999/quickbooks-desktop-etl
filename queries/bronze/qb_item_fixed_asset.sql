SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemfixedasset as ifa
-- << INCREMENTAL >> --
WHERE
    CAST(ifa.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records