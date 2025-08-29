-- =====================================================
-- DIAGNOSTIC QUERY - Let's see what's actually in the data
-- =====================================================

-- 1. First, let's check if we have ANY events in the last 30 days
WITH recent_events AS (
  SELECT COUNT(*) as total_events
  FROM `tilla-2-grind.klaviyo.events`
  WHERE DATE(datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
)
SELECT 'Total events in last 30 days' as check_type, total_events as count FROM recent_events;

-- 2. Let's look at a sample of event_properties to see the actual structure
SELECT 
  'Sample event_properties' as check_type,
  datetime,
  type,
  TO_JSON_STRING(attributes) as full_attributes,
  JSON_EXTRACT(attributes, '$.event_properties') as event_properties
FROM `tilla-2-grind.klaviyo.events`
WHERE datetime >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  AND attributes IS NOT NULL
LIMIT 10;

-- 3. Check what metric IDs we have
SELECT 
  'Metric IDs' as check_type,
  JSON_VALUE(relationships, '$.metric.data.id') as metric_id,
  COUNT(*) as event_count
FROM `tilla-2-grind.klaviyo.events`
WHERE DATE(datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
GROUP BY metric_id
ORDER BY event_count DESC
LIMIT 20;

-- 4. Find events that might have campaign data
SELECT 
  'Events with possible campaign data' as check_type,
  datetime,
  type,
  JSON_VALUE(relationships, '$.metric.data.id') as metric_id,
  TO_JSON_STRING(JSON_EXTRACT(attributes, '$.event_properties')) as event_props_string
FROM `tilla-2-grind.klaviyo.events`
WHERE DATE(datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  AND (
    TO_JSON_STRING(attributes) LIKE '%campaign%' 
    OR TO_JSON_STRING(attributes) LIKE '%Campaign%'
    OR TO_JSON_STRING(attributes) LIKE '%email%'
    OR TO_JSON_STRING(attributes) LIKE '%Email%'
  )
LIMIT 20;

-- 5. Check campaigns table
SELECT 
  'Campaigns in campaigns table' as check_type,
  COUNT(*) as campaign_count,
  MIN(updated_at) as oldest_campaign,
  MAX(updated_at) as newest_campaign
FROM `tilla-2-grind.klaviyo.campaigns`;