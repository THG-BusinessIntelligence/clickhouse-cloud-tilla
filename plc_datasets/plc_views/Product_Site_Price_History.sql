-- View: Product_Site_Price_History
CREATE OR REPLACE VIEW Product_Site_Price_History AS
SELECT
*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_History` 
WHERE Site IN (46, 37)
