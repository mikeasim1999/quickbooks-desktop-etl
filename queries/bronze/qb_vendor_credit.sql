SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.vendorcredit as vc
-- << INCREMENTAL >> --
WHERE
    CAST(vc.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records