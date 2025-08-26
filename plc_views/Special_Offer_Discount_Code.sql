-- View: Special_Offer_Discount_Code
CREATE OR REPLACE VIEW Special_Offer_Discount_Code AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offer_Discount_Code`
WHERE Site IN (46, 37)
