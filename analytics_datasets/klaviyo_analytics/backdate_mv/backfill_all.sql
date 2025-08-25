-- Comprehensive backfill script for all analytics_klaviyo tables
-- This script populates all analytics tables with historical data

-- 1. Backfill Campaign Performance
INSERT INTO analytics_klaviyo.campaign_performance
SELECT 
    c.id as campaign_id,
    c.campaign_name,
    c.status,
    c.channel,
    assumeNotNull(toDate(c.send_time)) as sent_date,
    -- Email metrics from events
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Received Email')) as emails_sent,
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Opened Email')) as emails_opened,
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Clicked Email')) as emails_clicked,
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Unsubscribed')) as unsubscribes,
    -- Calculate rates
    if(emails_sent > 0, emails_opened / emails_sent, 0) as open_rate,
    if(emails_opened > 0, emails_clicked / emails_opened, 0) as click_to_open_rate,
    if(emails_sent > 0, emails_clicked / emails_sent, 0) as click_rate
FROM data_klaviyo.campaigns c
LEFT JOIN data_klaviyo.events e ON toDate(e.event_datetime) = toDate(c.send_time)
WHERE c.status = 'Sent' AND c.send_time IS NOT NULL
GROUP BY c.id, c.campaign_name, c.status, c.channel, sent_date;

-- 2. Backfill Attribution Summary
INSERT INTO analytics_klaviyo.attribution_summary
SELECT 
    assumeNotNull(toDate(event_datetime)) as attribution_date,
    assumeNotNull(utm_source) as utm_source,
    assumeNotNull(utm_medium) as utm_medium,
    assumeNotNull(utm_campaign) as utm_campaign,
    COUNT(*) as total_events,
    COUNT(DISTINCT e.id) as unique_visitors,
    SUM(CASE WHEN metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Placed Order') THEN 1 ELSE 0 END) as conversions
FROM data_klaviyo.events e
WHERE (utm_source != '' OR utm_medium != '') AND event_datetime IS NOT NULL
GROUP BY attribution_date, utm_source, utm_medium, utm_campaign;

-- 3. Backfill Customer Lifecycle Summary
INSERT INTO analytics_klaviyo.customer_lifecycle_summary
SELECT 
    CASE 
        WHEN historic_clv = 0 THEN 'No Purchase History'
        WHEN historic_clv < 100 THEN 'Low Value'
        WHEN historic_clv < 500 THEN 'Medium Value'
        ELSE 'High Value'
    END as clv_segment,
    assumeNotNull(country) as country,
    COUNT(*) as customer_count,
    AVG(historic_clv) as avg_historic_clv,
    AVG(predicted_clv) as avg_predicted_clv,
    AVG(churn_probability) as avg_churn_probability,
    SUM(accepts_marketing) as marketing_opt_ins,
    COUNT(DISTINCT CASE WHEN last_event_date >= now() - INTERVAL 30 DAY THEN id END) as active_last_30_days
FROM data_klaviyo.profiles
WHERE country != ''
GROUP BY clv_segment, country;

-- 4. Backfill Daily Event Summary
INSERT INTO analytics_klaviyo.daily_event_summary
SELECT 
    toDate(e.event_datetime) as event_date,
    assumeNotNull(m.metric_name) as event_type,
    assumeNotNull(m.integration_name) as integration_name,
    COUNT(*) as event_count,
    COUNT(DISTINCT e.id) as unique_events
FROM data_klaviyo.events e
JOIN data_klaviyo.metrics m ON e.metric_id = m.id
WHERE e.event_datetime IS NOT NULL
  AND m.metric_name IS NOT NULL
  AND m.integration_name IS NOT NULL
GROUP BY event_date, event_type, integration_name;

-- 5. Backfill Segment Performance
INSERT INTO analytics_klaviyo.segment_performance
SELECT 
    CASE 
        WHEN accepts_marketing = 1 AND last_event_date >= now() - INTERVAL 30 DAY THEN 'Active Subscribers'
        WHEN accepts_marketing = 1 AND last_event_date >= now() - INTERVAL 90 DAY THEN 'Engaged Subscribers'
        WHEN accepts_marketing = 1 THEN 'Inactive Subscribers'
        ELSE 'Non-Subscribers'
    END as segment_name,
    toDate(now()) as metric_date,
    COUNT(*) as profile_count,
    AVG(historic_clv) as avg_clv,
    COUNT(DISTINCT country) as countries_represented
FROM data_klaviyo.profiles
GROUP BY segment_name, metric_date;

-- 6. Backfill Hourly Engagement
INSERT INTO analytics_klaviyo.hourly_engagement
SELECT 
    toHour(e.event_datetime) as hour_of_day,
    toDayOfWeek(e.event_datetime) as day_of_week,
    m.metric_name as event_type,
    COUNT(*) as event_count
FROM data_klaviyo.events e
JOIN data_klaviyo.metrics m ON e.metric_id = m.id
WHERE m.metric_name IN ('Opened Email', 'Clicked Email')
GROUP BY hour_of_day, day_of_week, event_type;