-- Materialized View for traffic_sources table
CREATE MATERIALIZED VIEW data_ga4.traffic_sources
ENGINE = MergeTree()
ORDER BY (date, property_id, sessionSource, sessionMedium)
AS
SELECT
    toDate(date) as date,
    toDate(endDate) as endDate,
    newUsers,
    sessions,
    toDate(startDate) as startDate,
    bounceRate,
    totalUsers,
    property_id,
    sessionMedium,
    sessionSource,
    screenPageViews,
    sessionsPerUser,
    averageSessionDuration,
    screenPageViewsPerSession
FROM raw_ga4.traffic_sources;