-- View: Stock_Details
CREATE OR REPLACE VIEW Stock_Details AS
SELECT
pd.Site,
sd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Stock_Details` sd 
JOIN `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim` pd
ON pd.Product_Id = sd.Product_Id
WHERE Site IN (46, 37)
