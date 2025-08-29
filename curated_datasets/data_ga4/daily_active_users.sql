-- Materialized View for Daily Active Users
CREATE MATERIALIZED VIEW data_ga4.daily_active_users
ENGINE = MergeTree()
ORDER BY (date, property_id)
AS
SELECT
    toDate(date) as date,
    toDate(endDate) as endDate,
    toDate(startDate) as startDate,
    property_id,
    active1DayUsers
FROM raw_ga4.daily_active_users;