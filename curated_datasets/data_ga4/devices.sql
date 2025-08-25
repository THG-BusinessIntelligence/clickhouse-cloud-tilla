-- Create materialized view for devices table
CREATE MATERIALIZED VIEW data_ga4.devices
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (property_id, date, deviceCategory, operatingSystem, browser)
SETTINGS index_granularity = 8192
POPULATE
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