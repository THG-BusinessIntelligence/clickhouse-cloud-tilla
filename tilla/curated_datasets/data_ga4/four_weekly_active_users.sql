-- Materialized View for four_weekly_active_users table
CREATE MATERIALIZED VIEW data_ga4.four_weekly_active_users
ENGINE = MergeTree()
ORDER BY (date, property_id)
AS
SELECT
    toDate(date) as date,
    toDate(endDate) as endDate,
    toDate(startDate) as startDate,
    property_id,
    active28DayUsers
FROM raw_ga4.four_weekly_active_users;