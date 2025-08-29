-- Physical Table: Customer_Details
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Details` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Customer_Details`
WHERE Site IN (46, 37, 231)