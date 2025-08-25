-- Backfill historical hourly engagement data
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