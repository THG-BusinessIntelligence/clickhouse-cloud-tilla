-- View: Subsite
CREATE OR REPLACE VIEW Subsite AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subsite`
WHERE Site IN (46, 37)
