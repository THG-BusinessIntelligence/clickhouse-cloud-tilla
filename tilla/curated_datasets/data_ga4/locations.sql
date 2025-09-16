-- Materialized View for locations table
CREATE MATERIALIZED VIEW data_ga4.locations
ENGINE = MergeTree()
ORDER BY (date, property_id, country, region)
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