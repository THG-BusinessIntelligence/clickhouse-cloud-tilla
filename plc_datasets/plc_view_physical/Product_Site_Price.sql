-- Physical Table: Product_Site_Price
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price`
WHERE Site IN (46, 37, 231)