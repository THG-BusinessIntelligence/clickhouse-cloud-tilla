-- Materialized View: Return_Order_Line
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Return_Order_Line
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Return_Order_Line`
WHERE Site IN (37,46)
