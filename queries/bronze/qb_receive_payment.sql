SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.receivepayment as rp
-- << INCREMENTAL >> --
WHERE
    CAST(rp.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records