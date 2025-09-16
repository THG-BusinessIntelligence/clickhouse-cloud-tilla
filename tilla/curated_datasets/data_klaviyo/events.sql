-- Create materialized view for Klaviyo events
CREATE MATERIALIZED VIEW data_klaviyo.events
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(event_datetime)
ORDER BY (event_datetime, id)
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(datetime)) as event_datetime,
    
    -- Extract from attributes JSON 
    JSONExtractInt(attributes, 'timestamp') as timestamp,
    JSONExtractString(attributes, 'uuid') as uuid,
    
    -- Event properties (most common/important fields)
    JSONExtractString(attributes, 'event_properties', '$event_id') as event_id,
    JSONExtractString(attributes, 'event_properties', 'device_type') as device_type,
    JSONExtractString(attributes, 'event_properties', 'hostname') as hostname,
    JSONExtractString(attributes, 'event_properties', 'page_url') as page_url,
    JSONExtractString(attributes, 'event_properties', 'href') as href,
    JSONExtractString(attributes, 'event_properties', 'uid') as uid,
    
    -- UTM parameters
    JSONExtractString(attributes, 'event_properties', 'utm_source') as utm_source,
    JSONExtractString(attributes, 'event_properties', 'utm_medium') as utm_medium,
    JSONExtractString(attributes, 'event_properties', 'utm_campaign') as utm_campaign,
    JSONExtractString(attributes, 'event_properties', 'utm_content') as utm_content,
    JSONExtractString(attributes, 'event_properties', 'utm_term') as utm_term,
    
    -- Product related fields
    JSONExtractString(attributes, 'event_properties', 'product_id') as product_id,
    JSONExtractFloat(attributes, 'event_properties', 'average_rating') as average_rating,
    JSONExtractInt(attributes, 'event_properties', 'review_count') as review_count,
    
    -- Session tracking
    JSONExtractBool(attributes, 'event_properties', 'unique_user') as unique_user,
    JSONExtractBool(attributes, 'event_properties', 'unique_session') as unique_session,
    JSONExtractBool(attributes, 'event_properties', 'unique_pageview') as unique_pageview,
    
    -- Relationships
    JSONExtractString(relationships, 'metric', 'data', 'id') as metric_id
    
FROM raw_klaviyo.events
WHERE id IS NOT NULL 
  AND datetime IS NOT NULL;