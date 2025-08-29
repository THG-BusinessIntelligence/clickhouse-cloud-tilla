-- Physical Table: Product_Dim
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim` AS
WITH products AS (
    SELECT DISTINCT site, Product_Id
    FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_Insert` ps
    WHERE ps.Site IN (46, 37, 231)
)
SELECT
    ps.Site,
    pd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Dim` pd
JOIN products ps
ON ps.Product_Id = pd.Product_Id