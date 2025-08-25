-- Create materialized view for Klaviyo metrics
CREATE MATERIALIZED VIEW data_klaviyo.metrics
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(updated_at)
ORDER BY (id, updated_at)
SETTINGS index_granularity = 8192
AS
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated)) as updated_at,
    
    -- Extract from attributes JSON
    JSONExtractString(attributes, 'name') as metric_name,
    toDateTime(JSONExtractString(attributes, 'created')) as created_at,
    -- Removed redundant updated_at extraction from JSON
    
    -- Integration name (this was already working)
    JSONExtractString(attributes, 'integration', 'name') as integration_name,
    
    -- Category is nested deeper - at integration.category.category
    JSONExtractString(attributes, 'integration', 'category', 'category') as integration_category,
    
    -- Integration IDs
    JSONExtractString(attributes, 'integration', 'id') as integration_id,
    JSONExtractString(attributes, 'integration', 'key') as integration_key,
    
    -- Category ID
    JSONExtractInt(attributes, 'integration', 'category', 'id') as category_id
    
FROM raw_klaviyo.metrics
WHERE id IS NOT NULL 
  AND updated IS NOT NULL;