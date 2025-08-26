-- Materialized View: Special_Offer_Discount_Code
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Special_Offer_Discount_Code
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offer_Discount_Code`
WHERE Site IN (46, 37)
