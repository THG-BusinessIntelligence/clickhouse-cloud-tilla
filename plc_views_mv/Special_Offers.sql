-- Materialized View: Special_Offers
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Special_Offers
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offers`
WHERE Site IN (46, 37)
