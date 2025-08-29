-- =====================================================
-- SIMPLIFIED Initial Backfill Query for Campaign Performance
-- =====================================================
-- Purpose: One-time historical data load (last 30 days)
-- This version avoids JSONPath issues with $ prefixed keys
-- =====================================================

INSERT INTO `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WITH event_data AS (
  -- Extract ALL Klaviyo events from the last 30 days first
  -- Based on your example: attributes has event_properties with Campaign Name
  SELECT
    DATE(e.datetime) AS event_date,
    
    -- Extract the full attributes and event_properties
    e.attributes,
    JSON_EXTRACT(e.attributes, '$.event_properties') AS event_props,
    
    -- Extract specific fields based on your example structure
    JSON_VALUE(e.attributes, '$.event_properties.Campaign Name') AS campaign_name_direct,
    JSON_VALUE(e.attributes, '$.event_properties.$message') AS message_id_direct,
    CAST(JSON_VALUE(e.attributes, '$.event_properties.$value') AS NUMERIC) AS revenue_direct,
    
    -- Profile ID from relationships
    JSON_VALUE(e.relationships, '$.profile.data.id') AS profile_id,
    
    -- Metric ID to identify event type
    JSON_VALUE(e.relationships, '$.metric.data.id') AS metric_id,
    
    -- Event type from type field
    e.type AS event_type,
    
    -- Event timestamp
    e.datetime AS event_timestamp
    
  FROM
    `tilla-2-grind.klaviyo.events` e
  WHERE
    -- Process last 30 days of data
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND e.datetime < CURRENT_TIMESTAMP()
    -- Remove restrictive filter - we'll filter after extraction
),

-- Filter for events that have campaign data
filtered_events AS (
  SELECT
    event_date,
    profile_id,
    metric_id,
    event_type,
    
    -- Use direct extraction or fallback to REGEXP
    COALESCE(
      campaign_name_direct,
      REGEXP_EXTRACT(TO_JSON_STRING(event_props), r'"Campaign Name":"([^"]+)"')
    ) AS campaign_name,
    
    COALESCE(
      message_id_direct,
      REGEXP_EXTRACT(TO_JSON_STRING(event_props), r'"\$message":"([^"]+)"')
    ) AS message_id,
    
    COALESCE(
      revenue_direct,
      CAST(REGEXP_EXTRACT(TO_JSON_STRING(event_props), r'"\$value":([0-9.]+)') AS NUMERIC)
    ) AS revenue,
    
    event_timestamp
  FROM
    event_data
  WHERE
    -- Only keep events that have either a campaign name or message ID
    campaign_name_direct IS NOT NULL
    OR message_id_direct IS NOT NULL
    OR TO_JSON_STRING(event_props) LIKE '%Campaign Name%'
),

-- Join with campaigns to get campaign_id
campaign_mapping AS (
  SELECT DISTINCT
    c.id AS campaign_id,
    JSON_VALUE(c.attributes, '$.name') AS campaign_name_from_campaigns
  FROM
    `tilla-2-grind.klaviyo.campaigns` c
),

-- Aggregate metrics by campaign and date
aggregated_metrics AS (
  SELECT
    e.event_date,
    COALESCE(cm.campaign_id, e.message_id) AS campaign_id,
    MAX(COALESCE(e.campaign_name, cm.campaign_name_from_campaigns)) AS campaign_name,
    e.message_id,
    
    -- Email metrics based on metric_id patterns
    COUNT(DISTINCT CASE 
      WHEN LOWER(e.metric_id) LIKE '%receiv%' OR LOWER(e.metric_id) LIKE '%send%'
      THEN e.profile_id 
    END) AS total_sends,
    
    COUNT(DISTINCT CASE 
      WHEN LOWER(e.metric_id) LIKE '%open%'
      THEN e.profile_id 
    END) AS unique_opens,
    
    COUNT(CASE 
      WHEN LOWER(e.metric_id) LIKE '%open%'
      THEN 1 
    END) AS total_opens,
    
    COUNT(DISTINCT CASE 
      WHEN LOWER(e.metric_id) LIKE '%click%'
      THEN e.profile_id 
    END) AS unique_clicks,
    
    COUNT(CASE 
      WHEN LOWER(e.metric_id) LIKE '%click%'
      THEN 1 
    END) AS total_clicks,
    
    -- Engagement metrics
    COUNT(DISTINCT CASE 
      WHEN LOWER(e.metric_id) LIKE '%unsub%'
      THEN e.profile_id 
    END) AS unsubscribes,
    
    COUNT(DISTINCT CASE 
      WHEN LOWER(e.metric_id) LIKE '%spam%'
      THEN e.profile_id 
    END) AS spam_reports,
    
    COUNT(DISTINCT CASE 
      WHEN LOWER(e.metric_id) LIKE '%bounce%'
      THEN e.profile_id 
    END) AS bounces,
    
    -- Conversion metrics
    COUNT(DISTINCT CASE 
      WHEN LOWER(e.metric_id) LIKE '%order%' AND e.revenue > 0
      THEN e.profile_id 
    END) AS placed_orders,
    
    COUNT(CASE 
      WHEN LOWER(e.metric_id) LIKE '%order%' AND e.revenue > 0
      THEN 1 
    END) AS ordered_products,
    
    -- Revenue
    SUM(COALESCE(e.revenue, 0)) AS total_revenue,
    
    -- Unique profiles
    COUNT(DISTINCT e.profile_id) AS unique_profiles
    
  FROM
    filtered_events e
  LEFT JOIN
    campaign_mapping cm ON e.campaign_name = cm.campaign_name_from_campaigns
  WHERE
    e.campaign_name IS NOT NULL OR e.message_id IS NOT NULL
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