-- Materialized View for website_overview table
CREATE MATERIALIZED VIEW data_ga4.website_overview
ENGINE = MergeTree()
ORDER BY (date, property_id)
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