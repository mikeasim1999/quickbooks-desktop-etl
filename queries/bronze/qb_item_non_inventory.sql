SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemnoninventory as ini
-- << INCREMENTAL >> --
WHERE
    CAST(ini.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records