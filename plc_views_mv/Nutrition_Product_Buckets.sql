-- Materialized View: Nutrition_Product_Buckets
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Nutrition_Product_Buckets
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT *
FROM `thg-prod-cloud-dw-thg-plc.Nutrition_Category_Data.Nutrition_Product_Buckets`
