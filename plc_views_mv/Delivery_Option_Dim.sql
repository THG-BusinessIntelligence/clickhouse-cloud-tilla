-- Materialized View: Delivery_Option_Dim
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Delivery_Option_Dim
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Delivery_Option_Dim`
