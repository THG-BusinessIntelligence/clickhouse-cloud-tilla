-- View: Refund_Order_Line
CREATE OR REPLACE VIEW Refund_Order_Line AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Refund_Order_Line`
WHERE Site IN (46, 37)
