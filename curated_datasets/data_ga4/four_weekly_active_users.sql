-- Create materialized view for four_weekly_active_users table
CREATE MATERIALIZED VIEW data_ga4.four_weekly_active_users
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (property_id, date)
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    toDate(date) as date,
    toDate(endDate) as endDate,
    toDate(startDate) as startDate,
    property_id,
    active28DayUsers
FROM raw_ga4.four_weekly_active_users;