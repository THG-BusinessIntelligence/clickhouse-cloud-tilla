-- =====================================================
-- Campaign Performance Summary Physical Table
-- =====================================================
-- Purpose: Pre-aggregated campaign metrics for fast querying
-- Update Frequency: Hourly via scheduled query
-- Data Retention: 180 days (auto-expiring partitions)
-- Cost Optimization: ~95% reduction vs querying raw events
-- =====================================================

-- Drop table if exists (for clean recreation)
DROP TABLE IF EXISTS `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`;

-- Create the physical table with partitioning and clustering
CREATE TABLE `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
(
  -- Date dimension
  event_date DATE NOT NULL,
  
  -- Campaign identifiers
  campaign_id STRING,
  campaign_name STRING,
  message_id STRING,
  
  -- Email metrics
  total_sends INT64,
  unique_opens INT64,
  total_opens INT64,
  unique_clicks INT64,
  total_clicks INT64,
  
  -- Engagement metrics
  unsubscribes INT64,
  spam_reports INT64,
  bounces INT64,
  
  -- Conversion metrics
  placed_orders INT64,
  ordered_products INT64,
  
  -- Revenue metrics
  total_revenue NUMERIC,
  
  -- Profile counts
  unique_profiles INT64,
  
  -- Engagement rates (calculated fields)
  open_rate FLOAT64,
  click_rate FLOAT64,
  click_to_open_rate FLOAT64,
  unsubscribe_rate FLOAT64,
  bounce_rate FLOAT64,
  
  -- Processing metadata
  last_updated_at TIMESTAMP NOT NULL,
  processing_timestamp TIMESTAMP NOT NULL
)
PARTITION BY event_date
CLUSTER BY campaign_id, campaign_name
OPTIONS(
  description="Pre-aggregated Klaviyo campaign performance metrics. Updated hourly with 2-hour processing window for late-arriving events.",
  labels=[("source", "klaviyo"), ("type", "analytics"), ("update_frequency", "hourly")],
  partition_expiration_days=180  -- Auto-expire old partitions to save storage
);

-- Create index for faster lookups (if needed)
-- Note: BigQuery doesn't support traditional indexes, but clustering provides similar benefits

-- Grant appropriate permissions
GRANT SELECT ON `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary` 
TO `roles/bigquery.dataViewer`;