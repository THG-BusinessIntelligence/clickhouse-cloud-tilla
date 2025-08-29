-- Query to understand what each metric_id represents
-- We need to find opens, clicks, sends, etc.

-- First, let's check the metrics table to map metric_id to metric names
SELECT 
  m.id as metric_id,
  JSON_VALUE(m.attributes, '$.name') as metric_name,
  JSON_VALUE(m.attributes, '$.integration.name') as integration_name,
  JSON_VALUE(m.attributes, '$.integration.category') as integration_category
FROM 
  `tilla-2-grind.klaviyo.metrics` m
WHERE 
  m.id IN ('LEjMZf', 'Qfbz2d', 'Jjw8dx', 'MQVnVi', 'HD4zhH', 'H23wF6', 'Qgnj4q')
ORDER BY 
  metric_name;

-- Also, let's check ALL metrics to find email event types
SELECT 
  m.id as metric_id,
  JSON_VALUE(m.attributes, '$.name') as metric_name,
  JSON_VALUE(m.attributes, '$.integration.name') as integration_name,
  JSON_VALUE(m.attributes, '$.integration.category') as integration_category
FROM 
  `tilla-2-grind.klaviyo.metrics` m
WHERE 
  LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%email%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%open%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%click%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%send%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%deliver%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%bounce%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%unsubscribe%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%spam%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%order%'
ORDER BY 
  metric_name
LIMIT 100;

-- Let's also check if there's a pattern in the event attributes
SELECT 
  JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
  e.type as event_type,
  -- Check for ESP field which might indicate email events
  COUNT(CASE WHEN JSON_VALUE(e.attributes, '$.event_properties."$ESP"') IS NOT NULL THEN 1 END) as has_esp,
  -- Check for value field which might indicate orders
  COUNT(CASE WHEN JSON_VALUE(e.attributes, '$.event_properties."$value"') IS NOT NULL THEN 1 END) as has_value,
  -- Check for specific event indicators
  COUNT(CASE WHEN JSON_VALUE(e.attributes, '$.event_properties."$event_id"') LIKE '%open%' THEN 1 END) as open_indicator,
  COUNT(CASE WHEN JSON_VALUE(e.attributes, '$.event_properties."$event_id"') LIKE '%click%' THEN 1 END) as click_indicator,
  COUNT(*) as total_events
FROM 
  `tilla-2-grind.klaviyo.events` e
WHERE 
  DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
  AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
  AND JSON_VALUE(e.relationships, '$.metric.data.id') IN ('LEjMZf', 'Qfbz2d', 'Jjw8dx', 'MQVnVi', 'HD4zhH', 'H23wF6', 'Qgnj4q')
GROUP BY 
  metric_id,
  event_type
ORDER BY 
  total_events DESC;