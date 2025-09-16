-- Materialized View for devices table
CREATE MATERIALIZED VIEW data_ga4.devices
ENGINE = MergeTree()
ORDER BY (date, property_id, deviceCategory)
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