-- Materialized View: Warehouse_Dim
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Warehouse_Dim
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Warehouse_Dim`
