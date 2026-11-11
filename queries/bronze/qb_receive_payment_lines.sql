SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.receivepayment_lines as rpili
-- << INCREMENTAL >> --
WHERE
    CAST(rpili.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records