-- Materialised View for Daily Active Users
CREATE MATERIALIZED VIEW data_ga4.daily_active_users
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(date)     -- Monthly partitions
ORDER BY (property_id, date)
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    toDate(date) as date,
    toDate(endDate) as endDate,
    toDate(startDate) as startDate,
    property_id,
    active1DayUsers
FROM raw_ga4.daily_active_users;