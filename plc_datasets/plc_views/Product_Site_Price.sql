-- View: Product_Site_Price
CREATE OR REPLACE VIEW Product_Site_Price AS
SELECT
*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price` 
WHERE Site IN (46, 37)
