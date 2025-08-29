-- Script to drop all physical tables from CloudDWConsolidated_Tilla dataset
-- This will remove all physical tables if they exist

DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Country`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Details`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Profile`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Delivery_Option_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Exchange_Rate`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Locale`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Nutrition_Product_Buckets`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount_Split`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Header`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Line`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Line_Status_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Payment_Status_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Status_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Type_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price_History`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Order_Line`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Shipment_Line`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Return_Order_Line`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions_Detail`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Site`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Calculator_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Discount_Code`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Trigger_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offers`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Details`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Status_Dim`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Header`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Schedule`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subsite`;
DROP TABLE IF EXISTS `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Warehouse_Dim`;