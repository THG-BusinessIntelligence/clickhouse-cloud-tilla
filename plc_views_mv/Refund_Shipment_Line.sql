-- Materialized View: Refund_Shipment_Line
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Refund_Shipment_Line
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Refund_Shipment_Line`
WHERE Site IN (37,46)
