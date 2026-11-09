SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.journalentry_includelineitems as jeili
-- << INCREMENTAL >> --
WHERE
    CAST(jeili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records