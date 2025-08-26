-- Materialized View: Refund_Order_Line
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Refund_Order_Line
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Refund_Order_Line`
WHERE Site IN (46, 37)
