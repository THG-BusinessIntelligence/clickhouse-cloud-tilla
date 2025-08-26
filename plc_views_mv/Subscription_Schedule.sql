-- Materialized View: Subscription_Schedule
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Subscription_Schedule
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subscription_Schedule`
WHERE Site IN (46, 37)
