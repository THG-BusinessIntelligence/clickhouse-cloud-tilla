-- Create materialized view for Klaviyo flows
CREATE MATERIALIZED VIEW data_klaviyo.flows
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(updated_at)
ORDER BY (id, updated_at)
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated)) as updated_at,
    
    -- Extract from attributes JSON
    JSONExtractString(attributes, 'name') as flow_name,
    JSONExtractString(attributes, 'status') as status,
    JSONExtractBool(attributes, 'archived') as is_archived,
    JSONExtractString(attributes, 'trigger_type') as trigger_type,
    toDateTime(JSONExtractString(attributes, 'created')) as created_at
    
FROM raw_klaviyo.flows
WHERE id IS NOT NULL 
  AND updated IS NOT NULL;