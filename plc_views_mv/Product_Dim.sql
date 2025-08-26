-- Materialized View: Product_Dim
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Product_Dim
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
WITH products AS (
    SELECT DISTINCT site, Product_Id 
    FROM `CloudDWConsolidated.Product_Site_Price_Insert` ps 
    WHERE ps.Site IN (46, 37)
)
SELECT
    ps.Site,
    pd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Dim` pd
JOIN products ps
ON ps.Product_Id = pd.Product_Id
