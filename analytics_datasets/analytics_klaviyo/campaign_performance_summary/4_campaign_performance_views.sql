-- =====================================================
-- Views for Campaign Performance Analytics
-- =====================================================
-- Purpose: Different perspectives on campaign data
-- Cost: No storage cost (views are virtual)
-- =====================================================

-- View 1: Campaign Performance Summary (Main View)
CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_campaign_performance`
AS
SELECT
  event_date,
  campaign_id,
  campaign_name,
  message_id,
  
  -- Core metrics
  total_sends,
  unique_opens,
  total_opens,
  unique_clicks,
  total_clicks,
  
  -- Engagement metrics
  unsubscribes,
  spam_reports,
  bounces,
  
  -- Conversion metrics
  placed_orders,
  ordered_products,
  total_revenue,
  
  -- Calculated rates (as percentages)
  ROUND(open_rate * 100, 2) AS open_rate_pct,
  ROUND(click_rate * 100, 2) AS click_rate_pct,
  ROUND(click_to_open_rate * 100, 2) AS click_to_open_rate_pct,
  ROUND(unsubscribe_rate * 100, 4) AS unsubscribe_rate_pct,
  ROUND(bounce_rate * 100, 4) AS bounce_rate_pct,
  
  -- Revenue metrics
  CASE 
    WHEN placed_orders > 0 
    THEN ROUND(total_revenue / placed_orders, 2) 
    ELSE 0 
  END AS avg_order_value,
  
  CASE 
    WHEN unique_clicks > 0 
    THEN ROUND(placed_orders / unique_clicks * 100, 2) 
    ELSE 0 
  END AS conversion_rate_pct,
  
  -- Metadata
  last_updated_at
  
FROM
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WHERE
  event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)  -- Last 90 days for performance
;

-- View 2: Today's Campaign Performance (Real-time monitoring)
CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_campaign_today`
AS
SELECT
  campaign_id,
  campaign_name,
  
  -- Aggregated metrics for today
  SUM(total_sends) AS sends_today,
  SUM(unique_opens) AS opens_today,
  SUM(unique_clicks) AS clicks_today,
  SUM(placed_orders) AS orders_today,
  SUM(total_revenue) AS revenue_today,
  
  -- Current rates
  ROUND(SAFE_DIVIDE(SUM(unique_opens), NULLIF(SUM(total_sends), 0)) * 100, 2) AS open_rate_today,
  ROUND(SAFE_DIVIDE(SUM(unique_clicks), NULLIF(SUM(total_sends), 0)) * 100, 2) AS click_rate_today,
  
  -- Last update
  MAX(last_updated_at) AS last_updated
  
FROM
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WHERE
  event_date = CURRENT_DATE()
GROUP BY
  campaign_id,
  campaign_name
ORDER BY
  revenue_today DESC
;

-- View 3: Top Performing Campaigns (Last 30 Days)
CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_top_campaigns`
AS
WITH campaign_aggregates AS (
  SELECT
    campaign_id,
    campaign_name,
    
    -- Aggregate metrics
    SUM(total_sends) AS total_sends,
    SUM(unique_opens) AS total_opens,
    SUM(unique_clicks) AS total_clicks,
    SUM(placed_orders) AS total_orders,
    SUM(total_revenue) AS total_revenue,
    
    -- Calculate rates
    ROUND(SAFE_DIVIDE(SUM(unique_opens), NULLIF(SUM(total_sends), 0)) * 100, 2) AS avg_open_rate,
    ROUND(SAFE_DIVIDE(SUM(unique_clicks), NULLIF(SUM(total_sends), 0)) * 100, 2) AS avg_click_rate,
    ROUND(SAFE_DIVIDE(SUM(placed_orders), NULLIF(SUM(unique_clicks), 0)) * 100, 2) AS conversion_rate,
    
    -- Date range
    MIN(event_date) AS first_send_date,
    MAX(event_date) AS last_send_date,
    COUNT(DISTINCT event_date) AS active_days
    
  FROM
    `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
  WHERE
    event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY
    campaign_id,
    campaign_name
)
SELECT
  *,
  -- Rank campaigns
  RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
  RANK() OVER (ORDER BY conversion_rate DESC) AS conversion_rank,
  RANK() OVER (ORDER BY avg_open_rate DESC) AS engagement_rank
FROM
  campaign_aggregates
WHERE
  total_sends >= 100  -- Minimum threshold for statistical significance
ORDER BY
  total_revenue DESC
;

-- View 4: Campaign Trend Analysis (Weekly Aggregates)
CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_campaign_weekly_trend`
AS
SELECT
  DATE_TRUNC(event_date, WEEK) AS week_start,
  campaign_id,
  campaign_name,
  
  -- Weekly aggregates
  SUM(total_sends) AS weekly_sends,
  SUM(unique_opens) AS weekly_opens,
  SUM(unique_clicks) AS weekly_clicks,
  SUM(placed_orders) AS weekly_orders,
  SUM(total_revenue) AS weekly_revenue,
  
  -- Weekly rates
  ROUND(SAFE_DIVIDE(SUM(unique_opens), NULLIF(SUM(total_sends), 0)) * 100, 2) AS weekly_open_rate,
  ROUND(SAFE_DIVIDE(SUM(unique_clicks), NULLIF(SUM(total_sends), 0)) * 100, 2) AS weekly_click_rate,
  
  -- Week-over-week calculations
  LAG(SUM(total_revenue)) OVER (PARTITION BY campaign_id ORDER BY DATE_TRUNC(event_date, WEEK)) AS prev_week_revenue,
  
  ROUND(
    (SUM(total_revenue) - LAG(SUM(total_revenue)) OVER (PARTITION BY campaign_id ORDER BY DATE_TRUNC(event_date, WEEK))) 
    / NULLIF(LAG(SUM(total_revenue)) OVER (PARTITION BY campaign_id ORDER BY DATE_TRUNC(event_date, WEEK)), 0) * 100, 
    2
  ) AS revenue_growth_pct
  
FROM
  `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
WHERE
  event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 WEEK)
GROUP BY
  week_start,
  campaign_id,
  campaign_name
ORDER BY
  week_start DESC,
  weekly_revenue DESC
;

-- View 5: Campaign Comparison Matrix
CREATE OR REPLACE VIEW `tilla-airbyte-staging.analytics_klaviyo.v_campaign_comparison`
AS
WITH campaign_stats AS (
  SELECT
    campaign_id,
    campaign_name,
    
    -- Performance metrics
    SUM(total_sends) AS total_sends,
    AVG(open_rate) * 100 AS avg_open_rate,
    AVG(click_rate) * 100 AS avg_click_rate,
    AVG(click_to_open_rate) * 100 AS avg_cto_rate,
    SUM(total_revenue) AS total_revenue,
    
    -- Calculate revenue per email sent
    SAFE_DIVIDE(SUM(total_revenue), NULLIF(SUM(total_sends), 0)) AS revenue_per_send,
    
    -- Count active days
    COUNT(DISTINCT event_date) AS campaign_days
    
  FROM
    `tilla-airbyte-staging.analytics_klaviyo.campaign_performance_summary`
  WHERE
    event_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY
    campaign_id,
    campaign_name
),
industry_benchmarks AS (
  -- Industry average benchmarks (can be adjusted based on your industry)
  SELECT
    20.0 AS benchmark_open_rate,  -- 20% industry average
    2.5 AS benchmark_click_rate,   -- 2.5% industry average
    12.5 AS benchmark_cto_rate     -- 12.5% click-to-open rate
)
SELECT
  cs.*,
  
  -- Compare to benchmarks
  CASE
    WHEN cs.avg_open_rate > ib.benchmark_open_rate THEN 'Above Average'
    WHEN cs.avg_open_rate >= ib.benchmark_open_rate * 0.8 THEN 'Average'
    ELSE 'Below Average'
  END AS open_rate_performance,
  
  CASE
    WHEN cs.avg_click_rate > ib.benchmark_click_rate THEN 'Above Average'
    WHEN cs.avg_click_rate >= ib.benchmark_click_rate * 0.8 THEN 'Average'
    ELSE 'Below Average'
  END AS click_rate_performance,
  
  -- Calculate performance score (weighted composite)
  ROUND(
    (cs.avg_open_rate / ib.benchmark_open_rate * 0.3) +
    (cs.avg_click_rate / ib.benchmark_click_rate * 0.3) +
    (cs.avg_cto_rate / ib.benchmark_cto_rate * 0.2) +
    (CASE WHEN cs.revenue_per_send > 0 THEN 0.2 ELSE 0 END),
    2
  ) AS performance_score
  
FROM
  campaign_stats cs
CROSS JOIN
  industry_benchmarks ib
ORDER BY
  performance_score DESC
;