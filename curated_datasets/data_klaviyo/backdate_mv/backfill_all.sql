-- Combined Klaviyo Backfill Script for All Tables

-- Backfill historical campaign data
INSERT INTO data_klaviyo.campaigns
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated_at)) as updated_at,
    
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


-- Backfill historical events data
INSERT INTO data_klaviyo.events
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


-- Backfill historical flows data
INSERT INTO data_klaviyo.flows
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


-- Backfill historical metrics data (with all columns)
INSERT INTO data_klaviyo.metrics
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated)) as updated_at,
    
    -- Extract from attributes JSON
    JSONExtractString(attributes, 'name') as metric_name,
    toDateTime(JSONExtractString(attributes, 'created')) as created_at,
    
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


-- Backfill without external_id and anonymous_id
INSERT INTO data_klaviyo.profiles
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated)) as updated_at,
    
    -- Timestamps
    parseDateTimeBestEffort(JSONExtractString(attributes, 'created')) as created_at,
    CASE 
        WHEN JSONExtractString(attributes, 'last_event_date') = '' THEN NULL
        ELSE parseDateTimeBestEffort(JSONExtractString(attributes, 'last_event_date'))
    END as last_event_date,
    
    -- Location data (excluding specific address/coordinates)
    JSONExtractString(attributes, 'location', 'country') as country,
    JSONExtractString(attributes, 'location', 'timezone') as timezone,
    
    -- Properties (non-PII)
    JSONExtractBool(attributes, 'properties', 'Accepts Marketing') as accepts_marketing,
    if(isNull(attributes), [], JSONExtractArrayRaw(assumeNotNull(attributes), 'properties', 'Shopify Tags')) as shopify_tags,
    
    -- Predictive analytics (all non-PII)
    JSONExtractFloat(attributes, 'predictive_analytics', 'historic_number_of_orders') as historic_number_of_orders,
    JSONExtractFloat(attributes, 'predictive_analytics', 'predicted_number_of_orders') as predicted_number_of_orders,
    JSONExtractFloat(attributes, 'predictive_analytics', 'average_days_between_orders') as average_days_between_orders,
    JSONExtractFloat(attributes, 'predictive_analytics', 'average_order_value') as average_order_value,
    JSONExtractFloat(attributes, 'predictive_analytics', 'historic_clv') as historic_clv,
    JSONExtractFloat(attributes, 'predictive_analytics', 'predicted_clv') as predicted_clv,
    JSONExtractFloat(attributes, 'predictive_analytics', 'total_clv') as total_clv,
    JSONExtractFloat(attributes, 'predictive_analytics', 'churn_probability') as churn_probability,
    CASE 
        WHEN JSONExtractString(attributes, 'predictive_analytics', 'expected_date_of_next_order') = '' THEN NULL
        ELSE parseDateTimeBestEffort(JSONExtractString(attributes, 'predictive_analytics', 'expected_date_of_next_order'))
    END as expected_date_of_next_order
    
FROM raw_klaviyo.profiles
WHERE id IS NOT NULL 
  AND updated IS NOT NULL;