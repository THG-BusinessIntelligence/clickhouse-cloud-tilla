-- Create materialized view for Klaviyo profiles
CREATE MATERIALIZED VIEW data_klaviyo.profiles
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(updated_at)
ORDER BY (id, updated_at)
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    -- Core fields
    id,
    type,
    assumeNotNull(toDateTime(updated)) as updated_at,
    
    -- Timestamps
    parseDateTimeBestEffort(JSONExtractString(attributes, 'created')) as created_at,
    CASE 
        WHEN JSONExtractString(attributes, 'last_event_date') = '' THEN NULL
        ELSE parseDateTimeBestEffort(JSONExtractString(attributes, 'last_event_date'))
    END as last_event_date,
    
    -- Location data (excluding specific address/coordinates)
    JSONExtractString(attributes, 'location', 'country') as country,
    JSONExtractString(attributes, 'location', 'timezone') as timezone,
    
    -- Properties (non-PII)
    JSONExtractBool(attributes, 'properties', 'Accepts Marketing') as accepts_marketing,
    if(isNull(attributes), [], JSONExtractArrayRaw(assumeNotNull(attributes), 'properties', 'Shopify Tags')) as shopify_tags,
    
    -- Predictive analytics (all non-PII)
    JSONExtractFloat(attributes, 'predictive_analytics', 'historic_number_of_orders') as historic_number_of_orders,
    JSONExtractFloat(attributes, 'predictive_analytics', 'predicted_number_of_orders') as predicted_number_of_orders,
    JSONExtractFloat(attributes, 'predictive_analytics', 'average_days_between_orders') as average_days_between_orders,
    JSONExtractFloat(attributes, 'predictive_analytics', 'average_order_value') as average_order_value,
    JSONExtractFloat(attributes, 'predictive_analytics', 'historic_clv') as historic_clv,
    JSONExtractFloat(attributes, 'predictive_analytics', 'predicted_clv') as predicted_clv,
    JSONExtractFloat(attributes, 'predictive_analytics', 'total_clv') as total_clv,
    JSONExtractFloat(attributes, 'predictive_analytics', 'churn_probability') as churn_probability,
    CASE 
        WHEN JSONExtractString(attributes, 'predictive_analytics', 'expected_date_of_next_order') = '' THEN NULL
        ELSE parseDateTimeBestEffort(JSONExtractString(attributes, 'predictive_analytics', 'expected_date_of_next_order'))
    END as expected_date_of_next_order
    
FROM raw_klaviyo.profiles
WHERE id IS NOT NULL 
  AND updated IS NOT NULL;