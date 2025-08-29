-- Physical Table: Subscription_Schedule
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Schedule` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subscription_Schedule`
WHERE Site IN (46, 37, 231)