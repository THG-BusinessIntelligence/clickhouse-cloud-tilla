-- Materialized View: Product_Site_Price_History
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Product_Site_Price_History
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_History` 
WHERE Site IN (46, 37)
