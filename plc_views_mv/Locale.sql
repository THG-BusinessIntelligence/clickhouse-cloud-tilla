-- Materialized View: Locale
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Locale
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Locale`
