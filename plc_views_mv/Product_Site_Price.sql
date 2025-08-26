-- Materialized View: Product_Site_Price
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Product_Site_Price
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price` 
WHERE Site IN (46, 37)
