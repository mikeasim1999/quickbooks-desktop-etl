SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.paymentmethod as pm
-- << INCREMENTAL >> --
WHERE
    CAST(pm.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records