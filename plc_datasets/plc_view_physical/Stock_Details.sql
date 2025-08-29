-- Physical Table: Stock_Details
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Details` AS
SELECT
    sd.*,
    ps.Site,
    ps.Product_Id,
    ps.Product_Name
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Stock_Details` sd 
LEFT JOIN `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_Insert` ps
ON sd.Product_Id = ps.Product_Id
WHERE Site IN (46, 37, 231)