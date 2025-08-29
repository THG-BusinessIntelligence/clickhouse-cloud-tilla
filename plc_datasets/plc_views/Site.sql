-- View: Site
CREATE OR REPLACE VIEW Site AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Site`
WHERE Site IN (46, 37)
