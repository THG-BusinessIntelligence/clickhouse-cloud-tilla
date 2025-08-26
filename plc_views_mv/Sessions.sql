-- Materialized View: Sessions
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Sessions
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT * 
FROM `thg-prod-data-engineering.thg_central_marketing.v2_Session_Details_F_All_Sites_*`
WHERE Site_Key IN (37, 46)
