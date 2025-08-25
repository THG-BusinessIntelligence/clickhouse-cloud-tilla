-- Create materialized view for Shopify countries
CREATE MATERIALIZED VIEW data_shopify.countries
ENGINE = ReplacingMergeTree()
ORDER BY (id)
SETTINGS index_granularity = 8192
AS
SELECT 
    -- Core fields
    id,
    code,
    name,
    shop_url,
    rest_of_world    
FROM raw_shopify.countries
WHERE id IS NOT NULL;