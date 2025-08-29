-- Initial backfill query for campaign performance summary table
-- SIMPLIFIED VERSION: Focuses on email metrics only (revenue attribution requires separate implementation)
-- Using confirmed metric_id values from diagnostic analysis

INSERT INTO `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WITH campaign_events AS (
  SELECT 
    DATE(e.datetime) as event_date,
    -- Campaign ID is the actual campaign or flow identifier
    COALESCE(
      JSON_VALUE(e.attributes, '$.event_properties."$flow"'),  -- Flow ID if it's a flow
      JSON_VALUE(e.attributes, '$.event_properties."$message"'), -- Or message as campaign ID
      e.id
    ) as campaign_id,
    JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') as campaign_name,
    -- Message ID is the specific message/variation
    JSON_VALUE(e.attributes, '$.event_properties."$message"') as message_id,
    JSON_VALUE(e.relationships, '$.profile.data.id') as profile_id,
    JSON_VALUE(e.relationships, '$.metric.data.id') as metric_id
  FROM 
    `tilla-2-grind.klaviyo.events` e
  WHERE 
    DATE(e.datetime) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND JSON_VALUE(e.attributes, '$.event_properties."Campaign Name"') IS NOT NULL
    -- Only include email-related metrics
    AND JSON_VALUE(e.relationships, '$.metric.data.id') IN (
      'Qfbz2d',  -- Received Email (sends)
      'LEjMZf',  -- Opened Email
      'Jjw8dx',  -- Clicked Email
      'MQVnVi',  -- Clicked email to unsubscribe
      'HD4zhH',  -- Bounced Email
      'Qgnj4q',  -- Marked Email as Spam
      'H23wF6'   -- Dropped Email (if exists)
    )
)
SELECT 
  event_date,
  campaign_id,
  campaign_name,
  message_id,
  -- Email metrics using confirmed metric_id values
  COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END) as total_sends,
  COUNT(DISTINCT CASE WHEN metric_id = 'LEjMZf' THEN profile_id END) as unique_opens,
  COUNT(CASE WHEN metric_id = 'LEjMZf' THEN 1 END) as total_opens,
  COUNT(DISTINCT CASE WHEN metric_id = 'Jjw8dx' THEN profile_id END) as unique_clicks,
  COUNT(CASE WHEN metric_id = 'Jjw8dx' THEN 1 END) as total_clicks,
  COUNT(DISTINCT CASE WHEN metric_id = 'MQVnVi' THEN profile_id END) as unsubscribes,
  COUNT(DISTINCT CASE WHEN metric_id = 'Qgnj4q' THEN profile_id END) as spam_reports,
  COUNT(DISTINCT CASE WHEN metric_id = 'HD4zhH' THEN profile_id END) as bounces,
  
  -- Conversion metrics - Set to 0 as email events don't contain revenue
  0 as placed_orders,
  CAST(NULL AS INT64) as ordered_products,  -- NULL indicates no data available
  CAST(0 AS NUMERIC) as total_revenue,  -- 0 as we can't attribute revenue from email events
  
  -- Count unique profiles that interacted
  COUNT(DISTINCT profile_id) as unique_profiles,
  
  -- Calculate rates - will be NULL when denominator is 0 (which is correct)
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'LEjMZf' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)
  ) as open_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'Jjw8dx' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)
  ) as click_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'Jjw8dx' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'LEjMZf' THEN profile_id END), 0)
  ) as click_to_open_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'MQVnVi' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)
  ) as unsubscribe_rate,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN metric_id = 'HD4zhH' THEN profile_id END),
    NULLIF(COUNT(DISTINCT CASE WHEN metric_id = 'Qfbz2d' THEN profile_id END), 0)
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

-- IMPORTANT NOTES:
-- 1. Email events contain NO revenue data - all $value fields are NULL
-- 2. Order events use different metric IDs (KEbtNb, PS4hrL, TZRZMF, etc.) and are NOT linked to campaigns
-- 3. NULL rates occur when there are 0 sends (can't divide by 0) - this is correct behavior
-- 4. campaign_id = the flow or campaign identifier, message_id = specific message variation
-- 5. For revenue attribution, consider using Klaviyo's API or building a separate attribution model