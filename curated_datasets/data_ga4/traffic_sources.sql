-- Create materialized view for traffic_sources table
CREATE MATERIALIZED VIEW data_ga4.traffic_sources
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (property_id, date, sessionSource, sessionMedium)
SETTINGS index_granularity = 8192
POPULATE
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