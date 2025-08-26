-- Materialized View: Subsite
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Subsite
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subsite`
WHERE Site IN (46, 37)
