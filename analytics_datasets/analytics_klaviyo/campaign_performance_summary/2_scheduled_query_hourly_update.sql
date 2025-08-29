-- =====================================================
-- Hourly Scheduled Query for Campaign Performance Updates
-- =====================================================
-- Schedule: Every hour
-- Processing Window: Last 2 hours (1-hour overlap for late events)
-- Method: MERGE with deduplication using GREATEST()
-- Estimated Cost: ~$0.0013 per run (~$11/year)
-- =====================================================

-- This query should be scheduled to run hourly in BigQuery
-- Use BigQuery Console > Scheduled Queries to set this up

MERGE tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary AS target
USING (
  WITH event_data AS (
    -- Extract campaign events from the last 2 hours
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
      tilla-2-grind.klaviyo.events e
    WHERE
      -- Process last 2 hours of data (1-hour overlap for late-arriving events)
      e.datetime >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 2 HOUR)
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
      tilla-2-grind.klaviyo.campaigns c
  ),
  
  -- Aggregate metrics by campaign and date
  aggregated_metrics AS (
    SELECT
      e.event_date,
      COALESCE(cm.campaign_id, e.message_id) AS campaign_id,  -- Use message_id as fallback
      MAX(COALESCE(e.campaign_name, cm.campaign_name_from_campaigns)) AS campaign_name,
      e.message_id,
      
      -- Email metrics based on event types
      COUNT(DISTINCT CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%send%' THEN e.profile_id END) AS total_sends,
      COUNT(DISTINCT CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%open%' THEN e.profile_id END) AS unique_opens,
      COUNT(CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%open%' THEN 1 END) AS total_opens,
      COUNT(DISTINCT CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%click%' THEN e.profile_id END) AS unique_clicks,
      COUNT(CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%click%' THEN 1 END) AS total_clicks,
      
      -- Engagement metrics
      COUNT(DISTINCT CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%unsub%' THEN e.profile_id END) AS unsubscribes,
      COUNT(DISTINCT CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%spam%' THEN e.profile_id END) AS spam_reports,
      COUNT(DISTINCT CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%bounce%' THEN e.profile_id END) AS bounces,
      
      -- Conversion metrics
      COUNT(DISTINCT CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%order%' THEN e.profile_id END) AS placed_orders,
      COUNT(CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%order%' THEN 1 END) AS ordered_products,
      
      -- Revenue
      SUM(CASE WHEN e.event_type = 'event' AND e.metric_id LIKE '%order%' THEN e.revenue ELSE 0 END) AS total_revenue,
      
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
) AS source

ON target.event_date = source.event_date 
  AND target.campaign_id = source.campaign_id

-- When matched, update with deduplication using GREATEST to prevent double-counting
WHEN MATCHED THEN
  UPDATE SET
    campaign_name = source.campaign_name,
    message_id = source.message_id,
    total_sends = GREATEST(target.total_sends, source.total_sends),
    unique_opens = GREATEST(target.unique_opens, source.unique_opens),
    total_opens = GREATEST(target.total_opens, source.total_opens),
    unique_clicks = GREATEST(target.unique_clicks, source.unique_clicks),
    total_clicks = GREATEST(target.total_clicks, source.total_clicks),
    unsubscribes = GREATEST(target.unsubscribes, source.unsubscribes),
    spam_reports = GREATEST(target.spam_reports, source.spam_reports),
    bounces = GREATEST(target.bounces, source.bounces),
    placed_orders = GREATEST(target.placed_orders, source.placed_orders),
    ordered_products = GREATEST(target.ordered_products, source.ordered_products),
    total_revenue = GREATEST(target.total_revenue, source.total_revenue),
    unique_profiles = GREATEST(target.unique_profiles, source.unique_profiles),
    open_rate = source.open_rate,
    click_rate = source.click_rate,
    click_to_open_rate = source.click_to_open_rate,
    unsubscribe_rate = source.unsubscribe_rate,
    bounce_rate = source.bounce_rate,
    last_updated_at = source.last_updated_at,
    processing_timestamp = source.processing_timestamp

-- When not matched, insert new records
WHEN NOT MATCHED THEN
  INSERT (
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
    open_rate,
    click_rate,
    click_to_open_rate,
    unsubscribe_rate,
    bounce_rate,
    last_updated_at,
    processing_timestamp
  )
  VALUES (
    source.event_date,
    source.campaign_id,
    source.campaign_name,
    source.message_id,
    source.total_sends,
    source.unique_opens,
    source.total_opens,
    source.unique_clicks,
    source.total_clicks,
    source.unsubscribes,
    source.spam_reports,
    source.bounces,
    source.placed_orders,
    source.ordered_products,
    source.total_revenue,
    source.unique_profiles,
    source.open_rate,
    source.click_rate,
    source.click_to_open_rate,
    source.unsubscribe_rate,
    source.bounce_rate,
    source.last_updated_at,
    source.processing_timestamp
  );