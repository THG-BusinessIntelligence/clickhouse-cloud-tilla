-- View: Order_Line
CREATE OR REPLACE VIEW Order_Line AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Line`
WHERE Site IN (46, 37)
