-- Diagnostic query to understand the actual JSON structure for campaign events
-- Let's look at different event types and their JSON structure

WITH sample_events AS (
  SELECT 
    type,
    SUBSTR(JSON_EXTRACT(attributes, '$.event_properties'), 1, 1000) as event_properties_sample,
    JSON_EXTRACT(attributes, '$.metric.name') as metric_name,
    JSON_EXTRACT(attributes, '$.metric.type') as metric_type,
    JSON_EXTRACT(attributes, '$.metric_id') as metric_id,
    JSON_EXTRACT(attributes, '$.ESP') as esp,
    JSON_EXTRACT(attributes, '$.message') as message,
    JSON_EXTRACT(attributes, '$.value') as value,
    -- Try different paths for campaign data
    JSON_VALUE(attributes, '$.event_properties."Campaign Name"') as campaign_name,
    JSON_VALUE(attributes, '$.event_properties."$message"') as message_id,
    JSON_VALUE(attributes, '$.event_properties."$event_id"') as event_id,
    JSON_VALUE(attributes, '$.event_properties."$flow"') as flow_id,
    -- Try extracting numeric values
    JSON_VALUE(attributes, '$.event_properties."$value"') as event_value,
    JSON_VALUE(attributes, '$.extra."$value"') as extra_value,
    JSON_VALUE(attributes, '$.value') as direct_value,
    -- Look at the whole attributes structure
    SUBSTR(TO_JSON_STRING(attributes), 1, 2000) as full_attributes_sample
  FROM 
    `grind-on-paytok.raw_klaviyo.events`
  WHERE 
    datetime BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY) AND CURRENT_TIMESTAMP()
    AND (
      type LIKE '%email%' 
      OR type LIKE '%campaign%'
      OR type LIKE '%message%'
      OR type LIKE '%click%'
      OR type LIKE '%open%'
      OR type LIKE '%send%'
      OR type LIKE '%bounce%'
      OR type LIKE '%unsubscribe%'
      OR type LIKE '%spam%'
      OR type LIKE '%order%'
      OR type = 'event'
    )
  LIMIT 100
)
SELECT 
  type,
  metric_name,
  metric_type,
  campaign_name,
  message_id,
  event_value,
  direct_value,
  SUBSTR(event_properties_sample, 1, 500) as event_props_preview,
  SUBSTR(full_attributes_sample, 1, 1000) as full_attrs_preview
FROM sample_events
ORDER BY type;