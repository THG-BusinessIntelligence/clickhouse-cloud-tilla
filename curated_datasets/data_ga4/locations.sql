-- View for locations table
CREATE VIEW data_ga4.locations
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