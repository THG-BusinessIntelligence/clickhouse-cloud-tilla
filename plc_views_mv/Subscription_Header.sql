-- Materialized View: Subscription_Header
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Subscription_Header
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subscription_Header`
WHERE Site IN (46, 37)
