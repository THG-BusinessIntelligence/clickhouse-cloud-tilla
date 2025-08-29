-- View: Subscription_Schedule
CREATE OR REPLACE VIEW Subscription_Schedule AS
SELECT
*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subscription_Schedule`
WHERE Site IN (46, 37)
