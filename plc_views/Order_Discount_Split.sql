-- View: Order_Discount_Split
CREATE OR REPLACE VIEW Order_Discount_Split AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Discount_Split`
WHERE Site IN (46, 37)
