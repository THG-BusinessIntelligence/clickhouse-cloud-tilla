-- Validation Query for Campaign Performance Summary Table
-- Run this after backfill to verify data accuracy

-- 1. Check overall metrics summary
WITH summary AS (
  SELECT 
    COUNT(*) as total_rows,
    COUNT(DISTINCT campaign_id) as unique_campaigns,
    COUNT(DISTINCT message_id) as unique_messages,
    SUM(total_sends) as total_sends,
    SUM(unique_opens) as total_unique_opens,
    SUM(unique_clicks) as total_unique_clicks,
    AVG(open_rate) as avg_open_rate,
    AVG(click_rate) as avg_click_rate
  FROM 
    `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
  WHERE 
    event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
)
SELECT * FROM summary;

-- 2. Check for data quality issues
SELECT 
  'Campaigns with 0 sends but has opens' as issue,
  COUNT(*) as count
FROM 
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WHERE 
  total_sends = 0 
  AND (unique_opens > 0 OR unique_clicks > 0);

-- 3. Compare with raw data to verify accuracy
WITH raw_counts AS (
  SELECT 
    DATE(e.datetime) as event_date,
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
    COUNT(DISTINCT JSON_VALUE(e.relationships, '$.profile.data.id')) as unique_profiles
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
    AND JSON_VALUE(e.relationships, '$.metric.data.id') IN ('Qfbz2d', 'LEjMZf', 'Jjw8dx')
  GROUP BY 1, 2, 3
),
summary_counts AS (
  SELECT 
    event_date,
    campaign_name,
    SUM(total_sends) as sends,
    SUM(unique_opens) as opens,
    SUM(unique_clicks) as clicks
  FROM 
    `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
  WHERE 
    event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  GROUP BY 1, 2
)
SELECT 
  r.event_date,
  r.campaign_name,
  r.metric_id,
  r.unique_profiles as raw_count,
  CASE 
    WHEN r.metric_id = 'Qfbz2d' THEN s.sends
    WHEN r.metric_id = 'LEjMZf' THEN s.opens
    WHEN r.metric_id = 'Jjw8dx' THEN s.clicks
  END as summary_count,
  CASE 
    WHEN r.metric_id = 'Qfbz2d' THEN r.unique_profiles - s.sends
    WHEN r.metric_id = 'LEjMZf' THEN r.unique_profiles - s.opens
    WHEN r.metric_id = 'Jjw8dx' THEN r.unique_profiles - s.clicks
  END as difference
FROM raw_counts r
LEFT JOIN summary_counts s
  ON r.event_date = s.event_date 
  AND r.campaign_name = s.campaign_name
WHERE ABS(CASE 
    WHEN r.metric_id = 'Qfbz2d' THEN r.unique_profiles - COALESCE(s.sends, 0)
    WHEN r.metric_id = 'LEjMZf' THEN r.unique_profiles - COALESCE(s.opens, 0)
    WHEN r.metric_id = 'Jjw8dx' THEN r.unique_profiles - COALESCE(s.clicks, 0)
  END) > 0
ORDER BY difference DESC
LIMIT 20;

-- 4. Check campaigns with NULL rates (these should have 0 sends)
SELECT 
  event_date,
  campaign_name,
  total_sends,
  unique_opens,
  unique_clicks,
  open_rate,
  click_rate,
  'Has NULL rate but should not' as issue
FROM 
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WHERE 
  (open_rate IS NULL AND total_sends > 0)
  OR (click_rate IS NULL AND total_sends > 0)
LIMIT 20;

-- 5. Top performing campaigns
SELECT 
  campaign_name,
  SUM(total_sends) as total_sends,
  SUM(unique_opens) as total_opens,
  SUM(unique_clicks) as total_clicks,
  SAFE_DIVIDE(SUM(unique_opens), NULLIF(SUM(total_sends), 0)) as overall_open_rate,
  SAFE_DIVIDE(SUM(unique_clicks), NULLIF(SUM(total_sends), 0)) as overall_click_rate,
  SAFE_DIVIDE(SUM(unique_clicks), NULLIF(SUM(unique_opens), 0)) as overall_click_to_open_rate
FROM 
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WHERE 
  event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  AND total_sends > 100  -- Only campaigns with meaningful volume
GROUP BY 1
ORDER BY overall_click_rate DESC
LIMIT 20;

-- 6. Check if campaign_id and message_id are different
SELECT 
  campaign_id,
  message_id,
  campaign_name,
  COUNT(*) as occurrences,
  CASE 
    WHEN campaign_id = message_id THEN 'SAME'
    WHEN campaign_id IS NULL THEN 'campaign_id NULL'
    WHEN message_id IS NULL THEN 'message_id NULL'
    ELSE 'DIFFERENT'
  END as id_comparison
FROM 
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WHERE 
  event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
GROUP BY 1, 2, 3
ORDER BY occurrences DESC
LIMIT 50;