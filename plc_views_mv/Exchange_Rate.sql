-- Materialized View: Exchange_Rate
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Exchange_Rate
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Exchange_Rate`
