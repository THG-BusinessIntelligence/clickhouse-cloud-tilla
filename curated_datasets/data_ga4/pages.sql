-- View for pages table
CREATE VIEW data_ga4.pages
AS
SELECT
    toDate(date) as date,
    toDate(endDate) as endDate,
    hostName,
    toDate(startDate) as startDate,
    bounceRate,
    property_id,
    screenPageViews,
    pagePathPlusQueryString
FROM raw_ga4.pages;