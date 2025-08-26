-- Materialized View: Order_Line
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Order_Line
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Line`
WHERE Site IN (46, 37)
