-- Backfill historical attribution summary data
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