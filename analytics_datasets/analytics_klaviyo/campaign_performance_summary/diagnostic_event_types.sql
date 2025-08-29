-- Check what event types exist and their counts
SELECT 
  type,
  COUNT(*) as event_count,
  -- Sample one record's attributes for each type
  ANY_VALUE(SUBSTR(TO_JSON_STRING(attributes), 1, 2000)) as sample_attributes
FROM 
  `grind-on-paytok.raw_klaviyo.events`
WHERE 
  datetime BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY) AND CURRENT_TIMESTAMP()
GROUP BY 
  type
ORDER BY 
  event_count DESC
LIMIT 50;

-- Also let's check specifically for campaign-related events
-- by looking at the event_properties content
WITH campaign_events AS (
  SELECT 
    type,
    JSON_VALUE(attributes, '$.event_properties."Campaign Name"') as campaign_name,
    TO_JSON_STRING(attributes) as full_attributes
  FROM 
    `grind-on-paytok.raw_klaviyo.events`
  WHERE 
    datetime BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY) AND CURRENT_TIMESTAMP()
  LIMIT 1000
)
SELECT 
  type,
  COUNT(*) as count,
  COUNT(DISTINCT campaign_name) as unique_campaigns,
  ANY_VALUE(campaign_name) as sample_campaign_name,
  ANY_VALUE(SUBSTR(full_attributes, 1, 1000)) as sample_attributes
FROM campaign_events
WHERE campaign_name IS NOT NULL
GROUP BY type
ORDER BY count DESC;