-- Script 1: Drop all regular views (plc_views)
-- Run this script in BigQuery to drop all existing regular views
-- Project: thg-prod-cloud-dw
-- Dataset: CloudDWConsolidated_Tilla

DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Country`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Details`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Profile`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Delivery_Option_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Exchange_Rate`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Locale`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Nutrition_Product_Buckets`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount_Split`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Header`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Line`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Line_Status_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Payment_Status_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Status_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Type_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price_History`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Order_Line`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Shipment_Line`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Return_Order_Line`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions_Detail`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Site`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Calculator_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Discount_Code`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Trigger_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offers`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Details`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Status_Dim`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Header`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Schedule`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subsite`;
DROP VIEW IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Warehouse_Dim`;

-- End of drop regular views script