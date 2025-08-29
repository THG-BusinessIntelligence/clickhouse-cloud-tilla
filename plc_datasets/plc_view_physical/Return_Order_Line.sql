-- Physical Table: Return_Order_Line
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Return_Order_Line` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Return_Order_Line`
WHERE Site IN (46, 37, 231)