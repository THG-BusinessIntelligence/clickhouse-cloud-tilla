-- Create materialized view for pages table
CREATE MATERIALIZED VIEW data_ga4.pages
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (property_id, date, hostName, pagePathPlusQueryString)
SETTINGS index_granularity = 8192
POPULATE
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