-- Physical Table: Customer_Profile
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Profile` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Customer_Profile`
WHERE Site IN (46, 37, 231)