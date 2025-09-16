-- Materialized View for Shopify countries
CREATE MATERIALIZED VIEW data_shopify.countries
ENGINE = MergeTree()
ORDER BY (id, code)
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