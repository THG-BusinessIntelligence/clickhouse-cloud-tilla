-- Physical Table: Refund_Shipment_Line
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Shipment_Line` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Refund_Shipment_Line`
WHERE Site IN (46, 37, 231)