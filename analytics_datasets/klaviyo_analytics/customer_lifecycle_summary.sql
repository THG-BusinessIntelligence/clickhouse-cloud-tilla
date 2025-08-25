CREATE TABLE analytics_klaviyo.customer_lifecycle_summary
ENGINE = MergeTree()  -- Changed to regular MergeTree
ORDER BY (clv_segment, assumeNotNull(country))  -- Handle nullable country
AS
SELECT 
    CASE 
        WHEN historic_clv = 0 THEN 'No Purchase History'
        WHEN historic_clv < 100 THEN 'Low Value'
        WHEN historic_clv < 500 THEN 'Medium Value'
        ELSE 'High Value'
    END as clv_segment,
    assumeNotNull(country) as country,  -- Make country non-nullable
    COUNT(*) as customer_count,
    AVG(historic_clv) as avg_historic_clv,
    AVG(predicted_clv) as avg_predicted_clv,
    AVG(churn_probability) as avg_churn_probability,
    SUM(accepts_marketing) as marketing_opt_ins,
    COUNT(DISTINCT CASE WHEN last_event_date >= now() - INTERVAL 30 DAY THEN id END) as active_last_30_days
FROM data_klaviyo.profiles
WHERE country != ''  -- Only include profiles with country data
GROUP BY clv_segment, country;