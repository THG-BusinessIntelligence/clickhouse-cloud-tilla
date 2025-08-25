-- Create materialized view for locations table
CREATE MATERIALIZED VIEW data_ga4.locations
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (property_id, date, country, region, city)
SETTINGS index_granularity = 8192
AS
SELECT 
    city,
    toDate(date) as date,
    region,
    country,
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
FROM raw_ga4.locations;