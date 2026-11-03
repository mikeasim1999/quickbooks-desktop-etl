SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.timetracking as tt
-- << INCREMENTAL >> --
WHERE
    CAST(tt.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records