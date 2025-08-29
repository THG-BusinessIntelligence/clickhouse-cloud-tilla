-- View: Refund_Shipment_Line
CREATE OR REPLACE VIEW Refund_Shipment_Line AS
SELECT
*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Refund_Shipment_Line`
WHERE Site IN (37,46)
