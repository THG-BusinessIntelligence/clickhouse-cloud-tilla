#!/usr/bin/env python3
"""
Script to create individual physical table SQL scripts for all plc tables
"""

import os

# Define the tables and their configurations
tables_config = {
    # Tables without Site filter
    "no_site_filter": [
        "Country",
        "Delivery_Option_Dim",
        "Exchange_Rate",
        "Locale",
        "Nutrition_Product_Buckets",
        "Order_Line_Status_Dim",
        "Order_Payment_Status_Dim",
        "Order_Status_Dim",
        "Order_Type_Dim",
        "Special_Offer_Calculator_Dim",
        "Special_Offer_Trigger_Dim",
        "Stock_Status_Dim",
        "Warehouse_Dim"
    ],
    # Tables with Site filter
    "with_site_filter": [
        "Customer_Details",
        "Customer_Profile",
        "Order_Discount",
        "Order_Discount_Split",
        "Order_Line",
        "Product_Site_Price",
        "Product_Site_Price_History",
        "Refund_Order_Line",
        "Refund_Shipment_Line",
        "Return_Order_Line",
        "Site",
        "Special_Offer_Discount_Code",
        "Special_Offers",
        "Subscription_Header",
        "Subscription_Schedule",
        "Subsite"
    ]
}

# Create individual scripts for tables without Site filter
for table_name in tables_config["no_site_filter"]:
    content = f"""-- Physical Table: {table_name}
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.{table_name}` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.{table_name}`"""
    
    with open(f"{table_name}.sql", "w") as f:
        f.write(content)
    print(f"Created {table_name}.sql")

# Create individual scripts for tables with Site filter
for table_name in tables_config["with_site_filter"]:
    content = f"""-- Physical Table: {table_name}
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.{table_name}` AS
SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.{table_name}`
WHERE Site IN (46, 37, 231)"""
    
    with open(f"{table_name}.sql", "w") as f:
        f.write(content)
    print(f"Created {table_name}.sql")

# Special case: Order_Header with explicit column list
order_header_content = """-- Physical Table: Order_Header
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Order_Header` AS
SELECT
    Order_Number,
    Site,
    Catalogue_Site,
    Site_Name,
    Order_Created,
    Source_System,
    Customer_Id,  
    Locale,
    Order_Status_Id,
    Order_Status,
    Order_Type_Id,
    Order_Type,
    Order_Qty,
    Order_Net_Qty,
    Order_Cancelled_Qty,
    Order_Refunded_Qty,
    Order_Replaced_Qty,
    Order_Returned_Qty,
    Order_Dispatched_Qty,
    Order_Outstanding_Qty,
    Order_Free_Gift_Qty,
    Order_Final_Qty,
    Order_Total_Value,
    Order_Shipping_Charge,
    Order_Shipping_Discount,
    Order_Product_Value,
    Order_Funding,
    Order_Tax,
    Order_Shipping_Tax,
    Order_GP,
    Order_List_Price,
    Order_Discount,
    Order_RRP,
    Order_MarkDown,
    Order_Cost,
    Credit_Used,
    Currency_Code,
    Exchange_Rate_To_GBP,
    Order_Sequence,
    Offer_Id,
    Discount_Code,
    Payment_Method,
    Payment_Status_Id,
    Payment_Status,
    External_Order_Number,
    Dispatched_Date,
    Expected_Dispatched_Date,
    Order_Reference,
    Guest,
    Affiliate_Refer,
    Sub_Payment_Type,
    Subscription_Id,
    Source_GA,
    Medium_GA,
    Campaign_GA,
    Channel_GA,
    Source_Ely,
    Medium_Ely,
    Campaign_Ely,
    Affil_Parameter_Ely,
    Channel_Ely,
    DeviceCategory,
    Platform_Version,
    Platform,
    Country_Code_Billing,  
    Country_Billing,       
    Country_Code_Shipping,  
    Country_Shipping,       
    Updated_Date,
    Loaded_Date
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Header`
WHERE Site IN (46, 37, 231)"""

with open("Order_Header.sql", "w") as f:
    f.write(order_header_content)
print("Created Order_Header.sql")

# Special case: Product_Dim with JOIN
product_dim_content = """-- Physical Table: Product_Dim
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim` AS
WITH products AS (
    SELECT DISTINCT site, Product_Id
    FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_Insert` ps
    WHERE ps.Site IN (46, 37, 231)
)
SELECT
    ps.Site,
    pd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Dim` pd
JOIN products ps
ON ps.Product_Id = pd.Product_Id"""

with open("Product_Dim.sql", "w") as f:
    f.write(product_dim_content)
print("Created Product_Dim.sql")

# Special case: Sessions with Site_Key
sessions_content = """-- Physical Table: Sessions
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions` AS
SELECT * 
FROM `thg-prod-data-engineering.thg_central_marketing.v2_Session_Details_F_All_Sites_*`
WHERE Site_Key IN (37, 46, 231)"""

with open("Sessions.sql", "w") as f:
    f.write(sessions_content)
print("Created Sessions.sql")

# Special case: Sessions_Detail with explicit columns
sessions_detail_content = """-- Physical Table: Sessions_Detail
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions_Detail` AS
SELECT 
    Date_Key,
    Date,
    Site_Key,
    Site_Title_Suffix,
    Country_Code,
    Country,
    City,
    Region,
    Continent,
    Device_Category,
    Device_Model,
    Device_Brand,
    Operating_System,
    Operating_System_Version,
    Browser,
    Browser_Version,
    Hostname,
    Language_Code,
    Default_Channel_Grouping,
    Landing_Page_Path,
    Exit_Page_Path,
    Exit_Page_Title,
    Sessions,
    Session_Duration,
    Screens_Or_Page_Views,
    Bounces,
    Goals_Completed_All_Goals,
    Transactions,
    Transaction_Revenue,
    Item_Quantity,
    Engaged_Sessions,
    Engagement_Rate,
    Ecommerce_Purchases,
    Total_Revenue,
    Unique_Events,
    Total_Events,
    Event_Count,
    Event_Value,
    Landing_Page_Title,
    Event_Name,
    New_Users,
    Active_Users,
    Conversions
FROM `thg-prod-data-engineering.thg_central_marketing.v2_Session_Level_1_All_Sites_*`
WHERE Site_Key IN (46, 37, 231)"""

with open("Sessions_Detail.sql", "w") as f:
    f.write(sessions_detail_content)
print("Created Sessions_Detail.sql")

# Special case: Stock_Details with JOIN
stock_details_content = """-- Physical Table: Stock_Details
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Stock_Details` AS
SELECT
    sd.*,
    ps.Site,
    ps.Product_Number,
    ps.Product_Name
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Stock_Details` sd 
LEFT JOIN `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_Insert` ps
ON sd.Product_Id = ps.Product_Id
WHERE Site IN (46, 37, 231)"""

with open("Stock_Details.sql", "w") as f:
    f.write(stock_details_content)
print("Created Stock_Details.sql")

print("\n✅ All individual physical table scripts created successfully!")