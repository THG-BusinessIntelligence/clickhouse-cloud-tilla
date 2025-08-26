-- View for devices table
CREATE VIEW data_ga4.devices
AS
SELECT
    toDate(date) as date,
    browser,
    toDate(endDate) as endDate,
    newUsers,
    sessions,
    toDate(startDate) as startDate,
    bounceRate,
    totalUsers,
    property_id,
    deviceCategory,
    operatingSystem,
    screenPageViews,
    sessionsPerUser,
    averageSessionDuration,
    screenPageViewsPerSession
FROM raw_ga4.devices;