-- Consolidated Table Summary Report for CloudDWConsolidated_Tilla Physical Tables
-- This script provides a comprehensive overview of all physical tables

-- Query 1: Summary statistics for all tables using __TABLES__ metadata
SELECT
  table_id AS Table_Name,
  row_count AS Row_Count,
  ROUND(size_bytes / (1024 * 1024), 2) AS Size_MB,
  ROUND(size_bytes / (1024 * 1024 * 1024), 3) AS Size_GB,
  DATETIME(TIMESTAMP_MILLIS(creation_time)) AS Created_At,
  DATETIME(TIMESTAMP_MILLIS(last_modified_time)) AS Last_Modified
FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.__TABLES__`
ORDER BY size_bytes DESC;

-- Query 2: Combined query to get earliest dates for all tables with date columns
-- COMPLETE QUERY - Run this as a separate query
-- Date columns verified from actual table schemas
WITH earliest_dates AS (
  -- Tables with Updated_Date column
  SELECT 'Customer_Details' AS table_nm, MIN(Updated_Date) AS earliest_dt, COUNT(*) AS rec_count 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Details`
  
  UNION ALL
  
  SELECT 'Customer_Profile', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Profile`
  
  UNION ALL
  `
  SELECT 'Order_Discount', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount`
  
  UNION ALL
  
  SELECT 'Order_Discount_Split', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount_Split`
  
  UNION ALL
  
  SELECT 'Order_Line', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Line`
  
  UNION ALL
  
  SELECT 'Product_Dim', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim`
  
  UNION ALL
  
  SELECT 'Product_Site_Price', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price`
  
  UNION ALL
  
  SELECT 'Product_Site_Price_History', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price_History`
  
  UNION ALL
  
  SELECT 'Refund_Order_Line', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Order_Line`
  
  UNION ALL
  
  SELECT 'Refund_Shipment_Line', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Shipment_Line`
  
  UNION ALL
  
  SELECT 'Return_Order_Line', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Return_Order_Line`
  
  UNION ALL
  
  SELECT 'Site', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Site`
  
  UNION ALL
  
  SELECT 'Special_Offer_Discount_Code', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Discount_Code`
  
  UNION ALL
  
  SELECT 'Special_Offers', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offers`
  
  UNION ALL
  
  SELECT 'Stock_Details', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Details`
  
  UNION ALL
  
  SELECT 'Subscription_Header', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Header`
  
  UNION ALL
  
  SELECT 'Subscription_Schedule', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Schedule`
  
  UNION ALL
  
  SELECT 'Subsite', MIN(Updated_Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subsite`
  
  UNION ALL
  
  -- Order_Header uses Order_Created as primary date
  SELECT 'Order_Header', MIN(Order_Created), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Header`
  
  UNION ALL
  
  -- Sessions uses Date column
  SELECT 'Sessions', MIN(Date), COUNT(*) 
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions`
  
  UNION ALL
  
  -- Sessions_Detail uses SessionDateTime
  SELECT 'Sessions_Detail', MIN(SessionDateTime), COUNT(*)
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions_Detail`
)
SELECT 
  table_nm AS Table_Name,
  CAST(earliest_dt AS STRING) AS Earliest_Record,
  rec_count AS Total_Records,
  CASE 
    WHEN earliest_dt IS NOT NULL THEN DATE_DIFF(CURRENT_DATE(), DATE(earliest_dt), DAY)
    ELSE NULL
  END AS Days_Of_Data
FROM earliest_dates
ORDER BY table_nm;

-- Dimension tables without date columns (for reference)
-- These tables don't have date columns to check for earliest records:
-- Country, Delivery_Option_Dim, Exchange_Rate, Locale, Nutrition_Product_Buckets,
-- Order_Line_Status_Dim, Order_Payment_Status_Dim, Order_Status_Dim,
-- Order_Type_Dim, Special_Offer_Calculator_Dim, Special_Offer_Trigger_Dim,
-- Stock_Status_Dim, Warehouse_Dim