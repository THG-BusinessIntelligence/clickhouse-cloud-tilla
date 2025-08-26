-- View for weekly active users
CREATE VIEW data_ga4.weekly_active_users
AS
SELECT
    date,
    endDate,
    startDate,
    property_id,
    active7DayUsers
FROM raw_ga4.weekly_active_users;