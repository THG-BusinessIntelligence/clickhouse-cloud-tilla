-- Simple diagnostic to understand event types for campaigns
-- Run this in BigQuery to see what event types exist

-- Check what event types exist for campaigns
SELECT 
  e.type as event_type,
  COUNT(*) as event_count,
  COUNT(DISTINCT JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"')) as unique_campaigns,
  ANY_VALUE(JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"')) as sample_campaign
FROM 
  `grind-on-paytok.raw_klaviyo.events` e
WHERE 
  DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
GROUP BY 
  e.type
ORDER BY 
  event_count DESC
LIMIT 50;

-- Also let's see a sample of raw events for a specific campaign
SELECT 
  e.type,
  e.datetime,
  JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
  JSON_VALUE(e.attributes, '$.event_properties."$message"') as message_id,
  JSON_VALUE(e.attributes, '$.event_properties."$value"') as value,
  SUBSTR(TO_JSON_STRING(e.attributes), 1, 500) as attributes_sample
FROM 
  `grind-on-paytok.raw_klaviyo.events` e
WHERE 
  DATE(e.datetime) = CURRENT_DATE()
  AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') = '1.7.2025 - Peanuts Launch - OTP Customers - 90 days - Purchased in the last 180 days - NL'
LIMIT 20;