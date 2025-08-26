-- View: Customer_Profile
CREATE OR REPLACE VIEW Customer_Profile AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Customer_Profile`
WHERE Site IN (46, 37)