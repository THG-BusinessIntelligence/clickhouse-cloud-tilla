-- Create materialized view for Klaviyo campaigns
CREATE MATERIALIZED VIEW data_klaviyo.campaigns
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(updated_at)
ORDER BY (id, updated_at)
SETTINGS index_granularity = 8192
AS
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated_at)) as updated_at,  -- Changed from 'updated' to 'updated_at'
    
    -- Extract from attributes JSON
    JSONExtractString(attributes, 'name') as campaign_name,
    JSONExtractString(attributes, 'status') as status,
    JSONExtractBool(attributes, 'archived') as is_archived,
    JSONExtractString(attributes, 'channel') as channel,
    
    -- Audiences - handle nullable by providing empty array as default
    if(isNull(attributes), [], JSONExtractArrayRaw(assumeNotNull(attributes), 'audiences', 'included')) as included_audiences,
    if(isNull(attributes), [], JSONExtractArrayRaw(assumeNotNull(attributes), 'audiences', 'excluded')) as excluded_audiences,
    
    -- Send options
    JSONExtractBool(attributes, 'send_options', 'use_smart_sending') as use_smart_sending,
    JSONExtractBool(attributes, 'send_options', 'ignore_unsubscribes') as ignore_unsubscribes,
    
    -- Tracking options
    JSONExtractBool(attributes, 'tracking_options', 'is_tracking_clicks') as is_tracking_clicks,
    JSONExtractBool(attributes, 'tracking_options', 'is_tracking_opens') as is_tracking_opens,
    JSONExtractBool(attributes, 'tracking_options', 'add_tracking_params') as add_tracking_params,
    
    -- Send strategy
    JSONExtractString(attributes, 'send_strategy', 'method') as send_strategy_method,
    JSONExtractString(attributes, 'send_strategy', 'options_static', 'datetime') as scheduled_send_time,
    JSONExtractBool(attributes, 'send_strategy', 'options_static', 'is_local') as is_local_time,
    
    -- Timestamps
    toDateTime(JSONExtractString(attributes, 'created_at')) as created_at,
    toDateTime(JSONExtractString(attributes, 'scheduled_at')) as scheduled_at,
    toDateTime(JSONExtractString(attributes, 'send_time')) as send_time,
    
    -- Campaign message relationship
    JSONExtractString(relationships, 'campaign-messages', 'data', 1, 'id') as campaign_message_id
    
FROM raw_klaviyo.campaigns
WHERE id IS NOT NULL 
  AND updated_at IS NOT NULL;  