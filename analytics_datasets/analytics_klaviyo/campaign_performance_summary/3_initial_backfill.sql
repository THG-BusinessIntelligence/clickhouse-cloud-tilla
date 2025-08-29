-- Initial backfill query for campaign performance summary table
-- This query aggregates Klaviyo events by campaign and date
-- Using actual metric_id values from the metrics table

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
  -- Email metrics using actual metric_id values
  -- Qfbz2d = Received Email (count as sends)
  COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END) as total_sends,
  -- LEjMZf = Opened Email
  COUNT(DISTINCT CASE WHEN metric_id = 'LEjMZf' THEN profile_id END) as unique_opens,
  COUNT(CASE WHEN metric_id = 'LEjMZf' THEN 1 END) as total_opens,
  -- Jjw8dx = Clicked Email
  COUNT(DISTINCT CASE WHEN metric_id = 'Jjw8dx' THEN profile_id END) as unique_clicks,
  COUNT(CASE WHEN metric_id = 'Jjw8dx' THEN 1 END) as total_clicks,
  -- Engagement metrics
  -- MQVnVi = Clicked email to unsubscribe
  COUNT(DISTINCT CASE WHEN metric_id = 'MQVnVi' THEN profile_id END) as unsubscribes,
  -- Qgnj4q = Marked Email as Spam
  COUNT(DISTINCT CASE WHEN metric_id = 'Qgnj4q' THEN profile_id END) as spam_reports,
  -- HD4zhH = Bounced Email
  COUNT(DISTINCT CASE WHEN metric_id = 'HD4zhH' THEN profile_id END) as bounces,
  -- Conversion metrics (keeping generic for orders as we don't have specific metric_id yet)
  COUNT(DISTINCT CASE WHEN LOWER(metric_id) LIKE '%order%' OR event_value > 0 THEN profile_id END) as placed_orders,
  SUM(CASE WHEN event_value > 0 THEN ordered_products END) as ordered_products,
  SUM(CASE WHEN event_value > 0 THEN event_value END) as total_revenue,
  -- Count unique profiles
  COUNT(DISTINCT profile_id) as unique_profiles,
  -- Calculate rates
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'LEjMZf' THEN profile_id END),  -- Opens
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)  -- Sends
  ) as open_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'Jjw8dx' THEN profile_id END),  -- Clicks
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)  -- Sends
  ) as click_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'Jjw8dx' THEN profile_id END),  -- Clicks
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'LEjMZf' THEN profile_id END), 0)  -- Opens
  ) as click_to_open_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'MQVnVi' THEN profile_id END),  -- Unsubscribes
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)  -- Sends
  ) as unsubscribe_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'HD4zhH' THEN profile_id END),  -- Bounces
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)  -- Sends
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

-- Metric ID Reference:
-- Qfbz2d = Received Email (used as sends)
-- LEjMZf = Opened Email
-- Jjw8dx = Clicked Email
-- MQVnVi = Clicked email to unsubscribe
-- HD4zhH = Bounced Email
-- Qgnj4q = Marked Email as Spam
-- H23wF6 = Dropped Email (not currently used in metrics)