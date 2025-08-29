-- Initial backfill query for campaign performance summary table
-- This query aggregates Klaviyo events by campaign and date
-- Metrics are counted by event type, not by extracting values from JSON

INSERT INTO `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WITH campaign_events AS (
  SELECT 
    DATE(e.datetime) as event_date,
    COALESCE(
      JSON_VALUE(e.attributes, '$.event_properties."$message"'),
      JSON_VALUE(e.attributes, '$.event_properties."$flow"'),
      JSON_VALUE(e.attributes, '$.event_properties."message_id"'),
      e.id
    ) as campaign_id,
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
    COALESCE(
      JSON_VALUE(e.attributes, '$.event_properties."$message"'),
      JSON_VALUE(e.attributes, '$.event_properties."message"')
    ) as message_id,
    JSON_VALUE(e.relationships, '$.profile.data.id') as profile_id,
    e.type as event_type,
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id,
    -- Extract values for revenue and product counts
    CAST(JSON_VALUE(e.attributes, '$.event_properties."$value"') AS FLOAT64) as event_value,
    CAST(JSON_VALUE(e.attributes, '$.event_properties."Ordered Product Count"') AS INT64) as ordered_products
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
)
SELECT 
  event_date,
  campaign_id,
  campaign_name,
  message_id,
  -- Count events by metric_id patterns (following the scheduled query pattern)
  COUNT(DISTINCT CASE WHEN metric_id LIKE '%send%' THEN profile_id END) as total_sends,
  COUNT(DISTINCT CASE WHEN metric_id LIKE '%open%' THEN profile_id END) as unique_opens,
  COUNT(CASE WHEN metric_id LIKE '%open%' THEN 1 END) as total_opens,
  COUNT(DISTINCT CASE WHEN metric_id LIKE '%click%' THEN profile_id END) as unique_clicks,
  COUNT(CASE WHEN metric_id LIKE '%click%' THEN 1 END) as total_clicks,
  -- Engagement metrics
  COUNT(DISTINCT CASE WHEN metric_id LIKE '%unsub%' THEN profile_id END) as unsubscribes,
  COUNT(DISTINCT CASE WHEN metric_id LIKE '%spam%' THEN profile_id END) as spam_reports,
  COUNT(DISTINCT CASE WHEN metric_id LIKE '%bounce%' THEN profile_id END) as bounces,
  -- Conversion metrics
  COUNT(DISTINCT CASE WHEN metric_id LIKE '%order%' THEN profile_id END) as placed_orders,
  SUM(CASE WHEN metric_id LIKE '%order%' THEN ordered_products END) as ordered_products,
  SUM(CASE WHEN metric_id LIKE '%order%' THEN event_value END) as total_revenue,
  -- Count unique profiles
  COUNT(DISTINCT profile_id) as unique_profiles,
  -- Calculate rates
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id LIKE '%open%' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id LIKE '%send%' THEN profile_id END), 0)
  ) as open_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id LIKE '%click%' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id LIKE '%send%' THEN profile_id END), 0)
  ) as click_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id LIKE '%click%' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id LIKE '%open%' THEN profile_id END), 0)
  ) as click_to_open_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id LIKE '%unsub%' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id LIKE '%send%' THEN profile_id END), 0)
  ) as unsubscribe_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id LIKE '%bounce%' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id LIKE '%send%' THEN profile_id END), 0)
  ) as bounce_rate,
  CURRENT_TIMESTAMP() as last_updated_at,
  CURRENT_TIMESTAMP() as processing_timestamp
FROM 
  campaign_events
GROUP BY 
  event_date,
  campaign_id,
  campaign_name,
  message_id;