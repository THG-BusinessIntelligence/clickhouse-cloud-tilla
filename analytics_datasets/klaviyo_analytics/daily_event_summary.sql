CREATE TABLE analytics_klaviyo.daily_event_summary
ENGINE = MergeTree()
ORDER BY (event_date, assumeNotNull(event_type))  -- Handle nullable event_type
AS
SELECT
    toDate(e.event_datetime) as event_date,
    assumeNotNull(m.metric_name) as event_type,  -- Make non-nullable
    assumeNotNull(m.integration_name) as integration_name,  -- Make non-nullable
    COUNT(*) as event_count,
    COUNT(DISTINCT e.id) as unique_events
FROM data_klaviyo.events e
JOIN data_klaviyo.metrics m ON e.metric_id = m.id
WHERE e.event_datetime IS NOT NULL
  AND m.metric_name IS NOT NULL  -- Filter out nulls
  AND m.integration_name IS NOT NULL  -- Filter out nulls
GROUP BY event_date, event_type, integration_name;