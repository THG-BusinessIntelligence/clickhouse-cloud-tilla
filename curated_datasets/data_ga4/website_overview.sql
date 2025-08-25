-- Create materialized view for website_overview table
CREATE MATERIALIZED VIEW data_ga4.website_overview
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (property_id, date)
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
    screenPageViews,
    sessionsPerUser,
    averageSessionDuration,
    screenPageViewsPerSession
FROM raw_ga4.website_overview;