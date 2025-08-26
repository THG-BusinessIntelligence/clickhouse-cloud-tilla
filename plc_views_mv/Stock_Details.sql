-- Materialized View: Stock_Details
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Stock_Details
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT
    pd.Site,
    sd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Stock_Details` sd 
JOIN `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim` pd
ON pd.Product_Id = sd.Product_Id
WHERE Site IN (46, 37)
