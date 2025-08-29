-- Script to analyze physical tables in CloudDWConsolidated_Tilla dataset
-- Shows table size, row count, and earliest record date

-- Get table statistics including size and row count
WITH table_stats AS (
  SELECT
    table_id AS table_name,
    row_count,
    ROUND(size_bytes / (1024 * 1024), 2) AS size_mb,
    ROUND(size_bytes / (1024 * 1024 * 1024), 3) AS size_gb,
    creation_time,
    last_modified_time
  FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.__TABLES__`
),

-- Define date columns for each table to check for earliest records
date_columns AS (
  SELECT 'Country' AS table_name, NULL AS date_column
  UNION ALL SELECT 'Customer_Details', 'Updated_Date'
  UNION ALL SELECT 'Customer_Profile', 'Updated_Date'
  UNION ALL SELECT 'Delivery_Option_Dim', NULL
  UNION ALL SELECT 'Exchange_Rate', NULL
  UNION ALL SELECT 'Locale', NULL
  UNION ALL SELECT 'Nutrition_Product_Buckets', NULL
  UNION ALL SELECT 'Order_Discount', 'Order_Created'
  UNION ALL SELECT 'Order_Discount_Split', 'Order_Created'
  UNION ALL SELECT 'Order_Header', 'Order_Created'
  UNION ALL SELECT 'Order_Line', 'Updated_Date'
  UNION ALL SELECT 'Order_Line_Status_Dim', NULL
  UNION ALL SELECT 'Order_Payment_Status_Dim', NULL
  UNION ALL SELECT 'Order_Status_Dim', NULL
  UNION ALL SELECT 'Order_Type_Dim', NULL
  UNION ALL SELECT 'Product_Dim', 'Updated_Date'
  UNION ALL SELECT 'Product_Site_Price', 'Updated_Date'
  UNION ALL SELECT 'Product_Site_Price_History', 'Updated_Date'
  UNION ALL SELECT 'Refund_Order_Line', 'Updated_Date'
  UNION ALL SELECT 'Refund_Shipment_Line', 'Updated_Date'
  UNION ALL SELECT 'Return_Order_Line', 'Updated_Date'
  UNION ALL SELECT 'Sessions', 'Date'
  UNION ALL SELECT 'Sessions_Detail', 'SessionDateTime'
  UNION ALL SELECT 'Site', 'Updated_Date'
  UNION ALL SELECT 'Special_Offer_Calculator_Dim', NULL
  UNION ALL SELECT 'Special_Offer_Discount_Code', 'Updated_Date'
  UNION ALL SELECT 'Special_Offer_Trigger_Dim', NULL
  UNION ALL SELECT 'Special_Offers', 'Updated_Date'
  UNION ALL SELECT 'Stock_Details', 'Updated_Date'
  UNION ALL SELECT 'Stock_Status_Dim', NULL
  UNION ALL SELECT 'Subscription_Header', 'Updated_Date'
  UNION ALL SELECT 'Subscription_Schedule', 'Updated_Date'
  UNION ALL SELECT 'Subsite', 'Updated_Date'
  UNION ALL SELECT 'Warehouse_Dim', NULL
)

-- Combine table stats with date column information
SELECT
  ts.table_name,
  ts.row_count,
  ts.size_mb,
  ts.size_gb,
  dc.date_column,
  ts.creation_time,
  ts.last_modified_time,
  CASE 
    WHEN dc.date_column IS NOT NULL THEN 
      CONCAT('Check earliest ', dc.date_column, ' with: SELECT MIN(', dc.date_column, ') FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.', ts.table_name, '`')
    ELSE 
      'No date column - dimension table'
  END AS earliest_record_query
FROM table_stats ts
LEFT JOIN date_columns dc ON ts.table_name = dc.table_name
ORDER BY ts.size_gb DESC;

-- Individual queries to get earliest records for tables with date columns
-- Run these queries separately to get the actual earliest dates:

-- Customer_Details
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Details`;

-- Customer_Profile
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Customer_Profile`;

-- Order_Discount
-- SELECT MIN(Order_Created) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount`;

-- Order_Discount_Split
-- SELECT MIN(Order_Created) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Discount_Split`;

-- Order_Header
-- SELECT MIN(Order_Created) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Header`;

-- Order_Line
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Line`;

-- Product_Dim
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim`;

-- Product_Site_Price
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price`;

-- Product_Site_Price_History
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Site_Price_History`;

-- Refund_Order_Line
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Order_Line`;

-- Refund_Shipment_Line
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Refund_Shipment_Line`;

-- Return_Order_Line
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Return_Order_Line`;

-- Sessions
-- SELECT MIN(Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions`;

-- Sessions_Detail
-- SELECT MIN(SessionDateTime) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions_Detail`;

-- Site
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Site`;

-- Special_Offer_Discount_Code
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offer_Discount_Code`;

-- Special_Offers
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Special_Offers`;

-- Stock_Details
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Details`;

-- Subscription_Header
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Header`;

-- Subscription_Schedule
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subscription_Schedule`;

-- Subsite
-- SELECT MIN(Updated_Date) AS earliest_date, COUNT(*) AS total_records FROM `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Subsite`;