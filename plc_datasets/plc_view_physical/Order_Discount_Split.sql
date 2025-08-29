-- Physical Table: Order_Discount_Split
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount_Split` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Discount_Split`
WHERE Site IN (46, 37, 231)