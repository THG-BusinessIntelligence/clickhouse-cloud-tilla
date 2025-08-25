-- Backfill historical lists data
INSERT INTO data_klaviyo.lists
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated)) as updated_at,
    
    -- Extract from attributes JSON
    JSONExtractString(attributes, 'name') as list_name,
    JSONExtractString(attributes, 'opt_in_process') as opt_in_process,
    toDateTime(JSONExtractString(attributes, 'created')) as created_at
    
FROM raw_klaviyo.lists
WHERE id IS NOT NULL 
  AND updated IS NOT NULL;