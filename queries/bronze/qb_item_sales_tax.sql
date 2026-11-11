SELECT *, NOW() AS LoadDatetime
FROM {SOURCE_SCHEMA}.itemsalestax as ist
-- << INCREMENTAL >> --
WHERE
    CAST(ist.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}' -- updated records