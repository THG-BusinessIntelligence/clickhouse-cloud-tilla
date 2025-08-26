-- Materialized View: Order_Type_Dim
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Order_Type_Dim
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Type_Dim`
