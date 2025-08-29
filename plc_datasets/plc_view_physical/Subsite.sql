-- Physical Table: Subsite
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subsite` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subsite`
WHERE Site IN (46, 37, 231)