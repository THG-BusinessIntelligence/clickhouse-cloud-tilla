-- Materialized View: Sessions_Detail
-- Refreshes every 5 minutes
CREATE OR REPLACE MATERIALIZED VIEW Sessions_Detail
OPTIONS(
    enable_refresh = true,
    refresh_interval_minutes = 5
)
AS
SELECT
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
WHERE Site_Key IN (46, 37)
