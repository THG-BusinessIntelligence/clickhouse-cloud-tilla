-- Physical Table: Sessions
CREATE OR REPLACE TABLE `thg-prod-cloud-dw.CloudDWConsolidated_Tilla.Sessions` AS
SELECT 
    Date,
    Hour,
    Site_key,
    Locale,
    Devicecategory,
    Platform,
    Native_App,
    Channel_Attribution_Id,
    Campaign,
    Country_Key,
    Bounces,
    Sessions,
    Users,
    Transactions,
    Page_Views,
    Created_At,
    Updated_At,
    Id
FROM `thg-prod-data-engineering.thg_central_marketing.v2_Session_Details_F_All_Sites_*`
WHERE Site_key IN (37, 46, 231)