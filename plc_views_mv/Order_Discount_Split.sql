-- Materialized View: Order_Discount_Split
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Order_Discount_Split
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Discount_Split`
WHERE Site IN (46, 37)
