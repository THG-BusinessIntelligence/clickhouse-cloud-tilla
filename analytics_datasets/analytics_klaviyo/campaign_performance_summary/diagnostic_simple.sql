-- Simple diagnostic to understand why metrics are 0
-- Run this in BigQuery to see actual metric_id values for campaigns

-- Check what metric_id values exist for campaign events
SELECT 
  JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
  e.type as event_type,
  COUNT(*) as event_count,
  COUNT(DISTINCT JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"')) as unique_campaigns,
  ANY_VALUE(JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"')) as sample_campaign
FROM 
  `tilla-2-grind.klaviyo.events` e
WHERE 
  DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
GROUP BY 
  metric_id,
  event_type
ORDER BY 
  event_count DESC
LIMIT 50;

-- Also check a specific campaign to see its events
SELECT 
  e.type,
  JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
  JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
  JSON_VALUE(e.attributes, '$.event_properties."$message"') as message_id,
  JSON_VALUE(e.attributes, '$.event_properties."$value"') as value,
  COUNT(*) as event_count
FROM 
  `tilla-2-grind.klaviyo.events` e
WHERE 
  DATE(e.datetime) = CURRENT_DATE()
  AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') = '1.7.2025 - Peanuts Launch - OTP Customers - 90 days - Purchased in the last 180 days - NL'
GROUP BY 
  e.type,
  metric_id,
  campaign_name,
  message_id,
  value
LIMIT 20;