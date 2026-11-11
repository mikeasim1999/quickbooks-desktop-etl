SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itempayment as ip
-- << INCREMENTAL >> --
WHERE
    CAST(ip.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records

