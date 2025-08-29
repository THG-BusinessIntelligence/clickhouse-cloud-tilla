-- =====================================================
-- Monitoring View for Campaign Performance Updates
-- =====================================================
-- Purpose: Monitor data freshness and update status
-- Use this to ensure the hourly updates are working
-- =====================================================

CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_monitoring_status`
AS
WITH update_status AS (
  SELECT
    -- Current time info
    CURRENT_TIMESTAMP() AS current_time,
    
    -- Latest data in the table
    MAX(event_date) AS latest_data_date,
    MAX(last_updated_at) AS last_update_time,
    
    -- Data freshness
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(last_updated_at), MINUTE) AS minutes_since_update,
    DATE_DIFF(CURRENT_DATE(), MAX(event_date), DAY) AS days_behind,
    
    -- Table statistics
    COUNT(DISTINCT campaign_id) AS total_campaigns,
    COUNT(DISTINCT event_date) AS total_days_with_data,
    COUNT(*) AS total_rows,
    
    -- Today's statistics
    SUM(CASE WHEN event_date = CURRENT_DATE() THEN 1 ELSE 0 END) AS rows_today,
    COUNT(DISTINCT CASE WHEN event_date = CURRENT_DATE() THEN campaign_id END) AS campaigns_today
    
  FROM
    `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
),
recent_updates AS (
  SELECT
    event_date,
    COUNT(DISTINCT campaign_id) AS campaigns_updated,
    MIN(last_updated_at) AS first_update,
    MAX(last_updated_at) AS last_update,
    COUNT(*) AS rows_affected
  FROM
    `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
  WHERE
    last_updated_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
  GROUP BY
    event_date
  ORDER BY
    event_date DESC
)
SELECT
  us.*,
  
  -- Health status
  CASE
    WHEN us.minutes_since_update <= 60 THEN '✅ Healthy - Updated within last hour'
    WHEN us.minutes_since_update <= 120 THEN '⚠️ Warning - Update delayed (>1 hour)'
    WHEN us.minutes_since_update <= 360 THEN '⚠️ Alert - Update significantly delayed (>2 hours)'
    ELSE '❌ Critical - No updates for >6 hours'
  END AS update_health_status,
  
  CASE
    WHEN us.days_behind = 0 THEN '✅ Current - Today\'s data available'
    WHEN us.days_behind = 1 THEN '⚠️ One day behind'
    ELSE CONCAT('❌ ', us.days_behind, ' days behind')
  END AS data_freshness_status,
  
  -- Recent update details
  (SELECT STRING_AGG(
    CONCAT(
      'Date: ', CAST(event_date AS STRING),
      ', Campaigns: ', CAST(campaigns_updated AS STRING),
      ', Last Update: ', CAST(last_update AS STRING)
    ), '\n' 
    ORDER BY event_date DESC
    LIMIT 5)
   FROM recent_updates
  ) AS recent_update_summary
  
FROM
  update_status us
;

-- Additional monitoring query to check for data anomalies
CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_data_quality_check`
AS
WITH daily_stats AS (
  SELECT
    event_date,
    COUNT(DISTINCT campaign_id) AS campaigns,
    SUM(total_sends) AS sends,
    SUM(unique_opens) AS opens,
    SUM(unique_clicks) AS clicks,
    AVG(open_rate) AS avg_open_rate,
    AVG(click_rate) AS avg_click_rate
  FROM
    `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
  WHERE
    event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY
    event_date
),
anomalies AS (
  SELECT
    event_date,
    campaigns,
    sends,
    opens,
    clicks,
    avg_open_rate,
    avg_click_rate,
    
    -- Calculate moving averages
    AVG(sends) OVER (ORDER BY event_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_sends_7d,
    AVG(opens) OVER (ORDER BY event_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_opens_7d,
    
    -- Detect anomalies
    CASE
      WHEN sends = 0 AND LAG(sends) OVER (ORDER BY event_date) > 0 THEN 'No sends (unexpected)'
      WHEN sends > 2 * AVG(sends) OVER (ORDER BY event_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) THEN 'Unusually high sends'
      WHEN sends < 0.5 * AVG(sends) OVER (ORDER BY event_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) THEN 'Unusually low sends'
      ELSE 'Normal'
    END AS send_anomaly,
    
    CASE
      WHEN avg_open_rate > 0.5 THEN 'Suspiciously high open rate (>50%)'
      WHEN avg_open_rate = 0 AND sends > 0 THEN 'Zero opens despite sends'
      ELSE 'Normal'
    END AS rate_anomaly
    
  FROM
    daily_stats
)
SELECT
  event_date,
  campaigns,
  sends,
  opens,
  clicks,
  ROUND(avg_open_rate * 100, 2) AS open_rate_pct,
  ROUND(avg_click_rate * 100, 2) AS click_rate_pct,
  send_anomaly,
  rate_anomaly,
  
  -- Flag dates that need investigation
  CASE
    WHEN send_anomaly != 'Normal' OR rate_anomaly != 'Normal' THEN '⚠️ Review needed'
    ELSE '✅ OK'
  END AS data_quality_status
  
FROM
  anomalies
ORDER BY
  event_date DESC
;

-- Query to check partition expiration and storage optimization
CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_storage_optimization`
AS
SELECT
  -- Table information
  'campaign_performance_summary' AS table_name,
  
  -- Partition statistics
  MIN(event_date) AS oldest_partition,
  MAX(event_date) AS newest_partition,
  COUNT(DISTINCT event_date) AS total_partitions,
  
  -- Calculate partition age
  DATE_DIFF(CURRENT_DATE(), MIN(event_date), DAY) AS oldest_data_days,
  
  -- Storage optimization info
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), MIN(event_date), DAY) > 180 THEN 
      CONCAT('⚠️ Data older than 180 days found. Consider manual cleanup. Oldest: ', CAST(MIN(event_date) AS STRING))
    ELSE 
      CONCAT('✅ All data within 180-day retention. Oldest: ', CAST(MIN(event_date) AS STRING))
  END AS storage_status,
  
  -- Row count by age buckets
  SUM(CASE WHEN DATE_DIFF(CURRENT_DATE(), event_date, DAY) <= 7 THEN 1 ELSE 0 END) AS rows_last_7_days,
  SUM(CASE WHEN DATE_DIFF(CURRENT_DATE(), event_date, DAY) <= 30 THEN 1 ELSE 0 END) AS rows_last_30_days,
  SUM(CASE WHEN DATE_DIFF(CURRENT_DATE(), event_date, DAY) <= 90 THEN 1 ELSE 0 END) AS rows_last_90_days,
  COUNT(*) AS total_rows
  
FROM
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
;