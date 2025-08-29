-- =====================================================
-- Initial Backfill Query for Campaign Performance
-- =====================================================
-- Purpose: One-time historical data load (last 30 days)
-- Estimated Cost: ~$0.50-1.88 depending on data volume
-- Run this ONCE after creating the table
-- =====================================================

-- This query loads the last 30 days of campaign performance data
-- After this, the hourly scheduled query will maintain the table

INSERT INTO `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WITH event_data AS (
  -- Extract campaign events from the last 30 days
  SELECT
    DATE(e.datetime) AS event_date,
    
    -- Extract campaign information from event properties
    JSON_VALUE(e.attributes, '$.event_properties."$message"') AS message_id,
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') AS campaign_name,
    
    -- Profile ID from relationships
    JSON_VALUE(e.relationships, '$.profile.data.id') AS profile_id,
    
    -- Metric ID to identify event type
    JSON_VALUE(e.relationships, '$.metric.data.id') AS metric_id,
    
    -- Event type from type field
    e.type AS event_type,
    
    -- Extract revenue if present
    CAST(JSON_VALUE(e.attributes, '$.event_properties."$value"') AS NUMERIC) AS revenue,
    
    -- Event timestamp
    e.datetime AS event_timestamp
    
  FROM
    `tilla-2-grind.klaviyo.events` e
  WHERE
    -- Process last 30 days of data
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND e.datetime < CURRENT_TIMESTAMP()
    -- Filter for email-related events (has ESP indicator or Campaign Name)
    AND (JSON_VALUE(e.attributes, '$.event_properties."$ESP"') IS NOT NULL
         OR JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL)
),

-- Join with campaigns to get campaign_id
campaign_mapping AS (
  SELECT DISTINCT
    c.id AS campaign_id,
    JSON_EXTRACT_SCALAR(c.attributes, '$.name') AS campaign_name_from_campaigns
  FROM
    `tilla-2-grind.klaviyo.campaigns` c
),

-- Aggregate metrics by campaign and date
aggregated_metrics AS (
  SELECT
    e.event_date,
    COALESCE(cm.campaign_id, e.message_id) AS campaign_id,  -- Use message_id as fallback
    MAX(COALESCE(e.campaign_name, cm.campaign_name_from_campaigns)) AS campaign_name,
    e.message_id,
    
    -- Email metrics based on event types and metric IDs
    COUNT(DISTINCT CASE 
      WHEN e.metric_id IN ('Qfbz2d', 'Received Email') 
      OR LOWER(e.campaign_name) LIKE '%email%' AND e.metric_id LIKE '%receiv%'
      THEN e.profile_id 
    END) AS total_sends,
    
    COUNT(DISTINCT CASE 
      WHEN e.metric_id IN ('Opened Email', 'Email Opened') 
      OR e.metric_id LIKE '%open%' 
      THEN e.profile_id 
    END) AS unique_opens,
    
    COUNT(CASE 
      WHEN e.metric_id IN ('Opened Email', 'Email Opened') 
      OR e.metric_id LIKE '%open%' 
      THEN 1 
    END) AS total_opens,
    
    COUNT(DISTINCT CASE 
      WHEN e.metric_id IN ('Clicked Email', 'Email Clicked') 
      OR e.metric_id LIKE '%click%' 
      THEN e.profile_id 
    END) AS unique_clicks,
    
    COUNT(CASE 
      WHEN e.metric_id IN ('Clicked Email', 'Email Clicked') 
      OR e.metric_id LIKE '%click%' 
      THEN 1 
    END) AS total_clicks,
    
    -- Engagement metrics
    COUNT(DISTINCT CASE 
      WHEN e.metric_id IN ('Unsubscribed', 'Email Unsubscribed') 
      OR e.metric_id LIKE '%unsub%' 
      THEN e.profile_id 
    END) AS unsubscribes,
    
    COUNT(DISTINCT CASE 
      WHEN e.metric_id IN ('Marked Email as Spam', 'Spam Report') 
      OR e.metric_id LIKE '%spam%' 
      THEN e.profile_id 
    END) AS spam_reports,
    
    COUNT(DISTINCT CASE 
      WHEN e.metric_id IN ('Bounced Email', 'Email Bounced') 
      OR e.metric_id LIKE '%bounce%' 
      THEN e.profile_id 
    END) AS bounces,
    
    -- Conversion metrics
    COUNT(DISTINCT CASE 
      WHEN e.metric_id IN ('Placed Order', 'Order Placed') 
      OR (e.metric_id LIKE '%order%' AND e.revenue > 0)
      THEN e.profile_id 
    END) AS placed_orders,
    
    COUNT(CASE 
      WHEN e.metric_id IN ('Placed Order', 'Order Placed') 
      OR (e.metric_id LIKE '%order%' AND e.revenue > 0)
      THEN 1 
    END) AS ordered_products,
    
    -- Revenue
    SUM(CASE 
      WHEN e.revenue > 0 
      THEN e.revenue 
      ELSE 0 
    END) AS total_revenue,
    
    -- Unique profiles
    COUNT(DISTINCT e.profile_id) AS unique_profiles
    
  FROM
    event_data e
  LEFT JOIN
    campaign_mapping cm ON e.campaign_name = cm.campaign_name_from_campaigns
  WHERE
    e.campaign_name IS NOT NULL OR cm.campaign_id IS NOT NULL
  GROUP BY
    e.event_date,
    campaign_id,
    e.message_id
)

-- Final selection with calculated rates
SELECT
  event_date,
  campaign_id,
  campaign_name,
  message_id,
  total_sends,
  unique_opens,
  total_opens,
  unique_clicks,
  total_clicks,
  unsubscribes,
  spam_reports,
  bounces,
  placed_orders,
  ordered_products,
  total_revenue,
  unique_profiles,
  
  -- Calculate engagement rates
  SAFE_DIVIDE(unique_opens, NULLIF(total_sends, 0)) AS open_rate,
  SAFE_DIVIDE(unique_clicks, NULLIF(total_sends, 0)) AS click_rate,
  SAFE_DIVIDE(unique_clicks, NULLIF(unique_opens, 0)) AS click_to_open_rate,
  SAFE_DIVIDE(unsubscribes, NULLIF(total_sends, 0)) AS unsubscribe_rate,
  SAFE_DIVIDE(bounces, NULLIF(total_sends, 0)) AS bounce_rate,
  
  -- Processing metadata
  CURRENT_TIMESTAMP() AS last_updated_at,
  CURRENT_TIMESTAMP() AS processing_timestamp
  
FROM
  aggregated_metrics
WHERE
  total_sends > 0 OR unique_opens > 0 OR unique_clicks > 0  -- Only include campaigns with activity
;