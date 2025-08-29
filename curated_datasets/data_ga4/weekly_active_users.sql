-- Materialized View for weekly active users
CREATE MATERIALIZED VIEW data_ga4.weekly_active_users
ENGINE = MergeTree()
ORDER BY (date, property_id)
AS
SELECT
    date,
    endDate,
    startDate,
    property_id,
    active7DayUsers
FROM raw_ga4.weekly_active_users;