SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.vendorcredit_includelineitems as vcili
-- << INCREMENTAL >> --
WHERE
    CAST(vcili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records