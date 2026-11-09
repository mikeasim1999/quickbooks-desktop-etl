SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.creditcardcharge_includelineitems as cccili
-- << INCREMENTAL >> --
WHERE
    CAST(cccili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records