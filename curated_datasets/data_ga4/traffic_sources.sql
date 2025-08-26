-- View for traffic_sources table
CREATE VIEW data_ga4.traffic_sources
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