-- Materialized View: Stock_Status_Dim
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Stock_Status_Dim
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Stock_Status_Dim`
