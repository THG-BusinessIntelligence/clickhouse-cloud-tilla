-- Materialized View: Order_Discount
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Order_Discount
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Discount`
WHERE Site IN (46, 37)
