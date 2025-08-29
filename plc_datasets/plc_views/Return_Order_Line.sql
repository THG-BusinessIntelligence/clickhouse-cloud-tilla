-- View: Return_Order_Line
CREATE OR REPLACE VIEW Return_Order_Line AS
SELECT
*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Return_Order_Line`
WHERE Site IN (37,46)
