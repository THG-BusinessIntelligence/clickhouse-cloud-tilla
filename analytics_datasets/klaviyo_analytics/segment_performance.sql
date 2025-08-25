CREATE TABLE analytics_klaviyo.segment_performance
ENGINE = MergeTree()
ORDER BY (segment_name, metric_date)
AS
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