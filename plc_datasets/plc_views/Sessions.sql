-- View: Sessions
CREATE OR REPLACE VIEW Sessions AS
SELECT * 
FROM `thg-prod-data-engineering.thg_central_marketing.v2_Session_Details_F_All_Sites_*`
WHERE Site_Key IN (37, 46)
