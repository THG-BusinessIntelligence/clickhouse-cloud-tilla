-- View: Subscription_Header
CREATE OR REPLACE VIEW Subscription_Header AS
SELECT
*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subscription_Header`
WHERE Site IN (46, 37)
