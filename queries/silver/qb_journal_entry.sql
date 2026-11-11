SELECT
    sje.TxnID AS journal_entry_id

    ,CAST(sje.TxnDate AS DATE) AS transaction_date

    ,CAST(sje.TxnNumber AS INT) AS transaction_number
    ,NULLIF(sje.RefNumber, '') AS reference_number

    ,CAST(sje.IsAdjustment AS BOOLEAN) AS is_adjustment

    ,NULLIF(sje.EditSequence, '') AS edit_sequence
    ,CAST(sje.TimeCreated AS TIMESTAMP) AS created_datetime
    ,CAST(sje.TimeModified AS TIMESTAMP) AS last_modified_datetime
    ,CAST(sje.loaddatetime AS TIMESTAMP) AS load_datetime
FROM {CATALOG}.{SOURCE_SCHEMA}.qb_journal_entry AS sje
-- << INCREMENTAL >> --
WHERE
  CAST(sje.TimeModified AS TIMESTAMP) >= '{WATERMARK_DATE}'
  