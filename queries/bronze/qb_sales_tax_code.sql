SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.salestaxcode as stc
-- << INCREMENTAL >> --
WHERE
    CAST(stc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records