#!/usr/bin/env python3
"""Script to create materialized view versions of all plc_views"""

import os

# Define all views from the plc_views folder as materialized views
views = {
    "Country": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Country`""",
    
    "Customer_Details": """SELECT 
    Customer_Id,
    Source_System,
    Catalogue_Site,
    Site,
    SCV_Key,
    Locale,
    Registered_Locale,
    Registered_Date,
    Receive_Newsletter,
    Receive_Newsletter_Updated_Date,
    SMS_Signup,
    Push_Notification_Signup,
    Last_Login_Date,
    Deleted_Date,
    Permanently_Deleted_Date,
    Email_Verified_State,
    Guest,
    Guest_to_Perm_Date,
    Last_Order_Placed,
    First_Order_Placed,
    Total_Orders,
    Total_Non_Cancelled_Orders,
    Total_Non_Cancelled_App_Orders,
    AOV,
    Referrals,
    Referral_Credit_Assigned,
    Referral_Credit_Used,
    Referral_Account_Credit,
    Referral_Account_Currency,
    Referral_Emails_Sent,
    Acquisition_Elysium_Channel_Attribution_Id,
    Acquisition_GA_Medium,
    Acquisition_GA_Source,
    Acquisition_Platform,
    Reward_Program_Opt_In,
    Reward_Program_Opt_In_Updated_Date,
    Updated_Date,
    Loaded_Date,
    publish_time,
    insert_publish_time
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Customer_Details`
WHERE Site IN (46, 37)""",
    
    "Customer_Profile": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Customer_Profile`
WHERE Site IN (46, 37)""",
    
    "Delivery_Option_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Delivery_Option_Dim`""",
    
    "Exchange_Rate": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Exchange_Rate`""",
    
    "Locale": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Locale`""",
    
    "Nutrition_Product_Buckets": """SELECT *
FROM `thg-prod-cloud-dw-thg-plc.Nutrition_Category_Data.Nutrition_Product_Buckets`""",
    
    "Order_Discount": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Discount`
WHERE Site IN (46, 37)""",
    
    "Order_Discount_Split": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Discount_Split`
WHERE Site IN (46, 37)""",
    
    "Order_Header": """SELECT
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
WHERE Site IN (46, 37)""",
    
    "Order_Line": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Line`
WHERE Site IN (46, 37)""",
    
    "Order_Line_Status_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Line_Status_Dim`""",
    
    "Order_Payment_Status_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Payment_Status_Dim`""",
    
    "Order_Status_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Status_Dim`""",
    
    "Order_Type_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Order_Type_Dim`""",
    
    "Product_Dim": """WITH products AS (
    SELECT DISTINCT site, Product_Id 
    FROM `CloudDWConsolidated.Product_Site_Price_Insert` ps 
    WHERE ps.Site IN (46, 37)
)
SELECT
    ps.Site,
    pd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Dim` pd
JOIN products ps
ON ps.Product_Id = pd.Product_Id""",
    
    "Product_Site_Price": """SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price` 
WHERE Site IN (46, 37)""",
    
    "Product_Site_Price_History": """SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Product_Site_Price_History` 
WHERE Site IN (46, 37)""",
    
    "Refund_Order_Line": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Refund_Order_Line`
WHERE Site IN (46, 37)""",
    
    "Refund_Shipment_Line": """SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Refund_Shipment_Line`
WHERE Site IN (37,46)""",
    
    "Return_Order_Line": """SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Return_Order_Line`
WHERE Site IN (37,46)""",
    
    "Sessions": """SELECT * 
FROM `thg-prod-data-engineering.thg_central_marketing.v2_Session_Details_F_All_Sites_*`
WHERE Site_Key IN (37, 46)""",
    
    "Sessions_Detail": """SELECT
    Site_Key,
    Locale,
    VisitId,  
    UniqueId,
    Platform_Version,
    Marketing_Cookie_Opt_In,
    Targeting_Cookie_Opt_In,
    DateKey,
    SessionDateTime,
    HitDateTime,
    IsEntrance,
    IsExit,
    PageOrder,
    Hit_Channel_Attribution_Id,
    Hit_Campaign,
    Hit_Source,
    Hit_Medium,
    Hit_Affil_Parameter,
    Hit_ReferralPath,
    Channel_Attribution_Id,
    Campaign,
    Source,
    Medium,
    Affil_Parameter,
    ReferralPath,
    SearchKeyword,
    Product_Id,
    List,
    Page_Type,
    Country,
    DeviceCategory,
    Platform,
    App_Version,
    Native_App,
    Order_Number,
    Customer_Id,
    PagePath,
    Hits_Type,
    Session_Page_Views,
    Session_Visits,
    Session_Bounces,
    Hit_Visits,
    Hit_Page_Views,
    Hit_Transactions,
    Updated_At
FROM `thg-prod-data-engineering.thg_central_marketing.v2_Session_Level_1_All_Sites_*`
WHERE Site_Key IN (46, 37)""",
    
    "Site": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Site`
WHERE Site IN (46, 37)""",
    
    "Special_Offer_Calculator_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offer_Calculator_Dim`""",
    
    "Special_Offer_Discount_Code": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offer_Discount_Code`
WHERE Site IN (46, 37)""",
    
    "Special_Offer_Trigger_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offer_Trigger_Dim`""",
    
    "Special_Offers": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Special_Offers`
WHERE Site IN (46, 37)""",
    
    "Stock_Details": """SELECT
    pd.Site,
    sd.*
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Stock_Details` sd 
JOIN `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Product_Dim` pd
ON pd.Product_Id = sd.Product_Id
WHERE Site IN (46, 37)""",
    
    "Stock_Status_Dim": """SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Stock_Status_Dim`""",
    
    "Subscription_Header": """SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subscription_Header`
WHERE Site IN (46, 37)""",
    
    "Subscription_Schedule": """SELECT *
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subscription_Schedule`
WHERE Site IN (46, 37)""",
    
    "Subsite": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Subsite`
WHERE Site IN (46, 37)""",
    
    "Warehouse_Dim": """SELECT * 
FROM `thg-prod-cloud-dw.CloudDWConsolidated.Warehouse_Dim`"""
}

# Create each materialized view file with 5-minute refresh
for view_name, view_query in views.items():
    file_path = f"{view_name}.sql"
    content = f"""-- Materialized View: {view_name}
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW {view_name}
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
{view_query}
"""
    
    # Write the file
    with open(file_path, 'w') as f:
        f.write(content)
    
    print(f"Created {file_path}")

print(f"\nSuccessfully created {len(views)} materialized view files with 5-minute refresh.")