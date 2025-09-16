-- Materialized View for pages table
CREATE MATERIALIZED VIEW data_ga4.pages
ENGINE = MergeTree()
ORDER BY (date, property_id, pagePathPlusQueryString)
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