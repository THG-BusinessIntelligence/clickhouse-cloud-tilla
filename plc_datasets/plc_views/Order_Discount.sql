-- View: Order_Discount
CREATE OR REPLACE VIEW Order_Discount AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Discount`
WHERE Site IN (46, 37)
