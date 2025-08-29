-- =====================================================
-- WORKING Initial Backfill Query for Campaign Performance
-- =====================================================
-- This is the SIMPLIFIED version that actually works
-- Run this INSTEAD of 3_initial_backfill_query_simplified.sql
-- =====================================================

INSERT INTO `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
SELECT
  DATE(e.datetime) AS event_date,
  
  -- Extract from the EXACT structure from your example
  JSON_VALUE(e.attributes, '$.event_properties."$message"') AS campaign_id,
  JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') AS campaign_name,
  JSON_VALUE(e.attributes, '$.event_properties."$message"') AS message_id,
  
  -- Count metrics based on metric_id from relationships
  COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%send%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END) AS total_sends,
  COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%open%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END) AS unique_opens,
  COUNT(CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%open%' THEN 1 END) AS total_opens,
  COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%click%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END) AS unique_clicks,
  COUNT(CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%click%' THEN 1 END) AS total_clicks,
  
  -- Placeholder values for now
  0 AS unsubscribes,
  0 AS spam_reports,
  0 AS bounces,
  0 AS placed_orders,
  0 AS ordered_products,
  0 AS total_revenue,
  
  COUNT(DISTINCT JSON_VALUE(e.relationships, '$.profile.data.id')) AS unique_profiles,
  
  -- Calculate rates
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%open%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END),
    NULLIF(COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%send%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END), 0)
  ) AS open_rate,
  
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%click%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END),
    NULLIF(COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%send%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END), 0)
  ) AS click_rate,
  
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%click%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END),
    NULLIF(COUNT(DISTINCT CASE WHEN JSON_VALUE(e.relationships, '$.metric.data.id') LIKE '%open%' THEN JSON_VALUE(e.relationships, '$.profile.data.id') END), 0)
  ) AS click_to_open_rate,
  
  0 AS unsubscribe_rate,
  0 AS bounce_rate,
  
  CURRENT_TIMESTAMP() AS last_updated_at,
  CURRENT_TIMESTAMP() AS processing_timestamp

FROM
  `tilla-2-grind.klaviyo.events` e
WHERE
  DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
GROUP BY
  event_date,
  campaign_id,
  campaign_name,
  message_id;