-- Initial backfill query for campaign performance summary table
-- This query aggregates Klaviyo events by campaign and date
-- Metrics are counted by event type, not by extracting values from JSON

INSERT INTO `grind-on-paytok.analytics_klaviyo.campaign_performance_summary`
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
    e.profile_id,
    e.type as event_type,
    -- Extract values for revenue and product counts
    CAST(JSON_VALUE(e.attributes, '$.event_properties."$value"') AS FLOAT64) as event_value,
    CAST(JSON_VALUE(e.attributes, '$.event_properties."Ordered Product Count"') AS INT64) as ordered_products
  FROM 
    `grind-on-paytok.raw_klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
)
SELECT 
  event_date,
  campaign_id,
  campaign_name,
  message_id,
  -- Count events by type
  -- Email sends (assuming type contains 'Sent' or 'Delivered')
  COUNT(CASE WHEN LOWER(event_type) LIKE '%sent%' OR LOWER(event_type) LIKE '%delivered%' THEN 1 END) as total_sends,
  -- Opens (unique by profile)
  COUNT(DISTINCT CASE WHEN LOWER(event_type) LIKE '%open%' THEN profile_id END) as unique_opens,
  COUNT(CASE WHEN LOWER(event_type) LIKE '%open%' THEN 1 END) as total_opens,
  -- Clicks (unique by profile)
  COUNT(DISTINCT CASE WHEN LOWER(event_type) LIKE '%click%' THEN profile_id END) as unique_clicks,
  COUNT(CASE WHEN LOWER(event_type) LIKE '%click%' THEN 1 END) as total_clicks,
  -- Unsubscribes
  COUNT(CASE WHEN LOWER(event_type) LIKE '%unsubscrib%' THEN 1 END) as unsubscribes,
  -- Spam reports
  COUNT(CASE WHEN LOWER(event_type) LIKE '%spam%' OR LOWER(event_type) LIKE '%complaint%' THEN 1 END) as spam_reports,
  -- Bounces
  COUNT(CASE WHEN LOWER(event_type) LIKE '%bounce%' THEN 1 END) as bounces,
  -- Orders and revenue (for events that have order data)
  COUNT(CASE WHEN LOWER(event_type) LIKE '%order%' OR LOWER(event_type) LIKE '%placed order%' THEN 1 END) as placed_orders,
  SUM(CASE WHEN LOWER(event_type) LIKE '%order%' THEN ordered_products END) as ordered_products,
  SUM(CASE WHEN LOWER(event_type) LIKE '%order%' THEN event_value END) as total_revenue,
  -- Count unique profiles
  COUNT(DISTINCT profile_id) as unique_profiles,
  -- Calculate rates (will be null if denominators are 0)
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN LOWER(event_type) LIKE '%open%' THEN profile_id END),
    NULLIF(COUNT(CASE WHEN LOWER(event_type) LIKE '%sent%' OR LOWER(event_type) LIKE '%delivered%' THEN 1 END), 0)
  ) * 100 as open_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN LOWER(event_type) LIKE '%click%' THEN profile_id END),
    NULLIF(COUNT(CASE WHEN LOWER(event_type) LIKE '%sent%' OR LOWER(event_type) LIKE '%delivered%' THEN 1 END), 0)
  ) * 100 as click_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN LOWER(event_type) LIKE '%click%' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN LOWER(event_type) LIKE '%open%' THEN profile_id END), 0)
  ) * 100 as click_to_open_rate,
  SAFE_DIVIDE(
    COUNT(CASE WHEN LOWER(event_type) LIKE '%unsubscrib%' THEN 1 END),
    NULLIF(COUNT(CASE WHEN LOWER(event_type) LIKE '%sent%' OR LOWER(event_type) LIKE '%delivered%' THEN 1 END), 0)
  ) * 100 as unsubscribe_rate,
  SAFE_DIVIDE(
    COUNT(CASE WHEN LOWER(event_type) LIKE '%bounce%' THEN 1 END),
    NULLIF(COUNT(CASE WHEN LOWER(event_type) LIKE '%sent%' OR LOWER(event_type) LIKE '%delivered%' THEN 1 END), 0)
  ) * 100 as bounce_rate,
  CURRENT_TIMESTAMP() as last_updated_at,
  CURRENT_TIMESTAMP() as processing_timestamp
FROM 
  campaign_events
GROUP BY 
  event_date,
  campaign_id,
  campaign_name,
  message_id;