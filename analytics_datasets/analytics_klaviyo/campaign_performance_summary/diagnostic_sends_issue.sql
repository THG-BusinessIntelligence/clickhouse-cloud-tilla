-- Diagnostic: Why are we missing sends for campaigns with opens?

-- 1. Check what metric IDs exist for campaigns with opens but no Qfbz2d (sends)
WITH campaigns_with_opens AS (
  SELECT DISTINCT
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(e.relationships, '$.metric.data.id') = 'LEjMZf'  -- Opens
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
),
all_metrics_for_these_campaigns AS (
  SELECT 
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
    COUNT(*) as event_count
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IN (
      SELECT campaign_name FROM campaigns_with_opens
    )
  GROUP BY 1, 2
)
SELECT 
  campaign_name,
  metric_id,
  event_count,
  CASE 
    WHEN metric_id = 'Qfbz2d' THEN 'Received Email (Send)'
    WHEN metric_id = 'LEjMZf' THEN 'Opened Email'
    WHEN metric_id = 'Jjw8dx' THEN 'Clicked Email'
    ELSE 'Unknown'
  END as metric_type
FROM all_metrics_for_these_campaigns
WHERE campaign_name IN (
  -- Only show campaigns that have opens but NO sends
  SELECT campaign_name 
  FROM all_metrics_for_these_campaigns
  WHERE metric_id = 'LEjMZf'
  AND campaign_name NOT IN (
    SELECT campaign_name 
    FROM all_metrics_for_these_campaigns 
    WHERE metric_id = 'Qfbz2d'
  )
)
ORDER BY campaign_name, event_count DESC
LIMIT 100;

-- 2. Check if there's another metric that could represent sends
SELECT 
  JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
  COUNT(*) as event_count,
  COUNT(DISTINCT JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"')) as unique_campaigns
FROM 
  `tilla-2-grind.klaviyo.events` e
WHERE 
  DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
  -- Look for email-related events
  AND (
    LOWER(e.type) LIKE '%email%'
    OR JSON_VALUE(e.attributes, '$.event_properties."$ESP"') IS NOT NULL
    OR JSON_VALUE(e.attributes, '$.event_properties."Email Domain"') IS NOT NULL
  )
GROUP BY 1
ORDER BY event_count DESC
LIMIT 20;

-- 3. Sample of campaigns with opens but no sends to understand the pattern
WITH problem_campaigns AS (
  SELECT 
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
    COUNT(DISTINCT JSON_VALUE(e.relationships, '$.profile.data.id')) as unique_profiles
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
  GROUP BY 1, 2
),
campaigns_with_issue AS (
  SELECT DISTINCT campaign_name
  FROM problem_campaigns
  WHERE metric_id = 'LEjMZf'  -- Has opens
  AND campaign_name NOT IN (
    SELECT campaign_name 
    FROM problem_campaigns 
    WHERE metric_id = 'Qfbz2d'  -- But no sends
  )
)
SELECT 
  campaign_name,
  COUNT(*) as total_events,
  STRING_AGG(DISTINCT metric_id) as metric_ids_found
FROM problem_campaigns
WHERE campaign_name IN (SELECT campaign_name FROM campaigns_with_issue)
GROUP BY 1
LIMIT 20;