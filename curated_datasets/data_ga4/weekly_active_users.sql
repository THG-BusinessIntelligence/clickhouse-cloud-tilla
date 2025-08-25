CREATE MATERIALIZED VIEW data_ga4.weekly_active_users
ENGINE = ReplacingMergeTree()
ORDER BY (date, property_id)
AS
SELECT
    date,
    endDate,
    startDate,
    property_id,
    active7DayUsers
FROM raw_ga4.weekly_active_users;