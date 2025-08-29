# Klaviyo Campaign Performance Analytics

## Overview
This directory contains the analytics layer for Klaviyo campaign performance data, designed to reduce query costs by ~95% while maintaining near real-time data freshness.

## Architecture

### Source Data
- **Project/Dataset**: `tilla-2-grind.klaviyo`
- **Main Tables**: 
  - `events` (300GB, 300M rows) - Contains all Klaviyo event data
  - `campaigns` - Campaign metadata
  - `flows` - Flow configurations
  - `lists` - List information
  - `metrics` - Additional metrics data

### Destination Analytics Layer
- **Project/Dataset**: `tilla-airbyte-staging.analytics_klaviyo`
- **Purpose**: Pre-aggregated, optimized tables for fast querying

## Implementation Files

### 1. Physical Table Creation
**File**: `1_create_campaign_performance_summary_table.sql`
- Creates the main physical table `campaign_performance_summary`
- Partitioned by date, clustered by campaign_id
- Auto-expires data after 180 days
- Contains pre-aggregated metrics: sends, opens, clicks, conversions, revenue

### 2. Scheduled Query (Hourly Updates)
**File**: `2_scheduled_query_hourly_update.sql`
- Run this as a scheduled query in BigQuery Console
- Schedule: Every hour
- Processing window: Last 2 hours (1-hour overlap for late-arriving events)
- Uses MERGE with deduplication to prevent double-counting
- Estimated cost: ~$0.0013 per run (~$11/year)

### 3. Initial Backfill
**File**: `3_initial_backfill_query.sql`
- One-time historical data load (last 30 days)
- Run this ONCE after creating the table
- Estimated cost: ~$0.50-1.88

### 4. Analytics Views
**File**: `4_campaign_performance_views.sql`

Creates 5 views for different perspectives:
- `v_campaign_performance` - Main campaign metrics view (last 90 days)
- `v_campaign_today` - Real-time monitoring of today's performance
- `v_top_campaigns` - Top performing campaigns (last 30 days)
- `v_campaign_weekly_trend` - Weekly trend analysis with growth metrics
- `v_campaign_comparison` - Campaign comparison with industry benchmarks

### 5. Monitoring Views
**File**: `5_monitoring_view.sql`

Creates 3 monitoring views:
- `v_monitoring_status` - Check data freshness and update status
- `v_data_quality_check` - Detect anomalies in campaign data
- `v_storage_optimization` - Monitor partition expiration and storage

## Setup Instructions

### Step 1: Create the Physical Table
```sql
-- Run the entire content of:
-- 1_create_campaign_performance_summary_table.sql
```

### Step 2: Initial Data Load
```sql
-- Run the entire content of:
-- 3_initial_backfill_query.sql
```

### Step 3: Create Views
```sql
-- Run the entire content of:
-- 4_campaign_performance_views.sql
-- 5_monitoring_view.sql
```

### Step 4: Set Up Scheduled Query
1. Go to BigQuery Console
2. Navigate to "Scheduled Queries"
3. Click "Create Scheduled Query"
4. Copy the content from `2_scheduled_query_hourly_update.sql`
5. Set schedule to run every hour
6. Configure notification preferences

## Monitoring

### Check Update Status
```sql
SELECT * FROM `tilla-airbyte-staging.analytics_klaviyo.v_monitoring_status`;
```

### Check Data Quality
```sql
SELECT * FROM `tilla-airbyte-staging.analytics_klaviyo.v_data_quality_check`
WHERE data_quality_status != '✅ OK';
```

### View Today's Performance
```sql
SELECT * FROM `tilla-airbyte-staging.analytics_klaviyo.v_campaign_today`
ORDER BY revenue_today DESC;
```

## Key Metrics Tracked

### Email Metrics
- `total_sends` - Total emails sent
- `unique_opens` - Unique recipients who opened
- `total_opens` - Total open events
- `unique_clicks` - Unique recipients who clicked
- `total_clicks` - Total click events

### Engagement Metrics
- `unsubscribes` - Unsubscribe count
- `spam_reports` - Spam report count
- `bounces` - Bounce count

### Conversion Metrics
- `placed_orders` - Number of orders placed
- `ordered_products` - Number of products ordered
- `total_revenue` - Total revenue generated

### Calculated Rates
- `open_rate` - Opens / Sends
- `click_rate` - Clicks / Sends
- `click_to_open_rate` - Clicks / Opens
- `unsubscribe_rate` - Unsubscribes / Sends
- `bounce_rate` - Bounces / Sends

## Cost Analysis

### Traditional Approach (Querying Raw Events)
- Cost per query: ~$0.34 (scanning 300GB)
- Monthly cost (100 queries): ~$34
- Annual cost: ~$408

### Optimized Approach (This Implementation)
- Initial setup: ~$1.00
- Hourly updates: ~$0.0013 each
- Monthly cost: ~$0.93
- Annual cost: ~$11
- **Savings: ~97%**

## Data Flow
```
Source (tilla-2-grind.klaviyo)          Analytics (tilla-airbyte-staging.analytics_klaviyo)
┌─────────────────────┐                 ┌──────────────────────────┐
│  events (300GB)     │ ──[Hourly]───> │ campaign_performance_    │
│  campaigns          │     Query       │ summary (physical table) │
│  flows              │                 └──────────────────────────┘
│  lists              │                            │
└─────────────────────┘                            ▼
                                        ┌──────────────────────────┐
                                        │  Views (no storage):     │
                                        │  - v_campaign_performance│
                                        │  - v_campaign_today      │
                                        │  - v_top_campaigns       │
                                        │  - v_campaign_weekly_trend│
                                        │  - v_campaign_comparison │
                                        └──────────────────────────┘
```

## Troubleshooting

### Issue: Data not updating
1. Check monitoring status: `SELECT * FROM v_monitoring_status`
2. Verify scheduled query is running in BigQuery Console
3. Check for errors in scheduled query logs

### Issue: Missing campaigns
1. Verify campaign name exists in events data
2. Check if campaign_id mapping is correct in campaigns table
3. Review the JSON extraction paths in the queries

### Issue: Incorrect metrics
1. Verify metric_id mapping for event types
2. Check JSON extraction paths for attributes
3. Review deduplication logic in MERGE statement

## Future Enhancements

1. **Add Flow Performance**: Similar table for Klaviyo flows
2. **Add List Segmentation**: Track performance by list/segment
3. **Add Attribution**: Multi-touch attribution analysis
4. **Add Predictive Metrics**: ML-based performance predictions
5. **Add Real-time Streaming**: Use Dataflow for real-time updates

## Notes

- The SQL files may show linting errors in some editors due to BigQuery-specific syntax
- All queries are optimized for BigQuery and follow best practices
- Table names use backticks due to hyphens in project names
- Partition expiration (180 days) helps control storage costs