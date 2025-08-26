-- Materialized View: Customer_Profile
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Customer_Profile
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Customer_Profile`
WHERE Site IN (46, 37)
