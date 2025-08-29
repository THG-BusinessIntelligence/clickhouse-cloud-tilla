-- Physical Table: Product_Site_Price_History
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price_History` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_History`
WHERE Site IN (46, 37, 231)