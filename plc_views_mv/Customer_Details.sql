-- Materialized View: Customer_Details
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Customer_Details
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT 
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
WHERE Site IN (46, 37)
