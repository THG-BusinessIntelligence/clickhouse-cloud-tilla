-- Materialized View: Site
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Site
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Site`
WHERE Site IN (46, 37)
