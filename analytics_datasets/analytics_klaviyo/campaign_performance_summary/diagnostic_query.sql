-- Diagnostic Query to Understand Klaviyo Events Data Structure
-- This query helps us understand what data is actually available

-- 1. Check what metric IDs exist and their counts
WITH metric_analysis AS (
  SELECT 
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
    JSON_VALUE(e.relationships, '$.metric.data.type') as metric_type,
    e.type as event_type,
    COUNT(*) as event_count,
    COUNT(DISTINCT JSON_VALUE(e.relationships, '$.profile.data.id')) as unique_profiles
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
  GROUP BY 1, 2, 3
  ORDER BY event_count DESC
  LIMIT 50
)
SELECT * FROM metric_analysis;

-- 2. Sample of actual event properties to understand structure
WITH sample_events AS (
  SELECT 
    e.id,
    e.type as event_type,
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
    -- Check various potential value fields
    JSON_VALUE(e.attributes, '$.event_properties."$value"') as dollar_value,
    JSON_VALUE(e.attributes, '$.event_properties.value') as value_no_dollar,
    JSON_VALUE(e.attributes, '$.event_properties."Value"') as value_capital,
    JSON_VALUE(e.attributes, '$.event_properties."Ordered Product Count"') as ordered_product_count,
    JSON_VALUE(e.attributes, '$.event_properties."Item Count"') as item_count,
    JSON_VALUE(e.attributes, '$.event_properties."Items"') as items,
    -- Check bounce/spam/unsubscribe fields
    JSON_VALUE(e.attributes, '$.event_properties."$event_id"') as event_id,
    JSON_VALUE(e.attributes, '$.event_properties."Subject"') as subject,
    -- Full attributes for inspection
    e.attributes as full_attributes
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
  LIMIT 20
)
SELECT * FROM sample_events;

-- 3. Check specific metric IDs we're using
WITH metric_check AS (
  SELECT 
    'Qfbz2d' as metric_id,
    'Expected: Received Email' as expected_meaning,
    COUNT(*) as count_in_last_7_days
  FROM `tilla-2-grind.klaviyo.events` e
  WHERE JSON_VALUE(e.relationships, '$.metric.data.id') = 'Qfbz2d'
    AND DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  
  UNION ALL
  
  SELECT 
    'LEjMZf' as metric_id,
    'Expected: Opened Email' as expected_meaning,
    COUNT(*) as count_in_last_7_days
  FROM `tilla-2-grind.klaviyo.events` e
  WHERE JSON_VALUE(e.relationships, '$.metric.data.id') = 'LEjMZf'
    AND DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  
  UNION ALL
  
  SELECT 
    'Jjw8dx' as metric_id,
    'Expected: Clicked Email' as expected_meaning,
    COUNT(*) as count_in_last_7_days
  FROM `tilla-2-grind.klaviyo.events` e
  WHERE JSON_VALUE(e.relationships, '$.metric.data.id') = 'Jjw8dx'
    AND DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  
  UNION ALL
  
  SELECT 
    'MQVnVi' as metric_id,
    'Expected: Unsubscribe' as expected_meaning,
    COUNT(*) as count_in_last_7_days
  FROM `tilla-2-grind.klaviyo.events` e
  WHERE JSON_VALUE(e.relationships, '$.metric.data.id') = 'MQVnVi'
    AND DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  
  UNION ALL
  
  SELECT 
    'HD4zhH' as metric_id,
    'Expected: Bounced Email' as expected_meaning,
    COUNT(*) as count_in_last_7_days
  FROM `tilla-2-grind.klaviyo.events` e
  WHERE JSON_VALUE(e.relationships, '$.metric.data.id') = 'HD4zhH'
    AND DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  
  UNION ALL
  
  SELECT 
    'Qgnj4q' as metric_id,
    'Expected: Marked as Spam' as expected_meaning,
    COUNT(*) as count_in_last_7_days
  FROM `tilla-2-grind.klaviyo.events` e
  WHERE JSON_VALUE(e.relationships, '$.metric.data.id') = 'Qgnj4q'
    AND DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
)
SELECT * FROM metric_check ORDER BY count_in_last_7_days DESC;

-- 4. Check for order/revenue events
WITH order_events AS (
  SELECT 
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
    e.type as event_type,
    COUNT(*) as event_count,
    SUM(CAST(JSON_VALUE(e.attributes, '$.event_properties."$value"') AS NUMERIC)) as total_revenue,
    AVG(CAST(JSON_VALUE(e.attributes, '$.event_properties."$value"') AS NUMERIC)) as avg_revenue,
    COUNT(CASE WHEN JSON_VALUE(e.attributes, '$.event_properties."$value"') IS NOT NULL THEN 1 END) as events_with_value
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND (
      LOWER(e.type) LIKE '%order%' 
      OR LOWER(e.type) LIKE '%purchase%'
      OR CAST(JSON_VALUE(e.attributes, '$.event_properties."$value"') AS NUMERIC) > 0
    )
  GROUP BY 1, 2
  ORDER BY event_count DESC
)
SELECT * FROM order_events;

-- 5. Look at the metrics table to understand what each metric_id means
SELECT 
  m.id as metric_id,
  JSON_VALUE(m.attributes, '$.name') as metric_name,
  JSON_VALUE(m.attributes, '$.integration.name') as integration_name,
  JSON_VALUE(m.attributes, '$.integration.category') as integration_category,
  m.type,
  m.attributes
FROM 
  `tilla-2-grind.klaviyo.metrics` m
WHERE 
  m.id IN ('Qfbz2d', 'LEjMZf', 'Jjw8dx', 'MQVnVi', 'HD4zhH', 'Qgnj4q')
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%order%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%purchase%'
  OR LOWER(JSON_VALUE(m.attributes, '$.name')) LIKE '%revenue%'
ORDER BY metric_name;