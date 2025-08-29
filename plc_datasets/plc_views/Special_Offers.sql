-- View: Special_Offers
CREATE OR REPLACE VIEW Special_Offers AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offers`
WHERE Site IN (46, 37)
