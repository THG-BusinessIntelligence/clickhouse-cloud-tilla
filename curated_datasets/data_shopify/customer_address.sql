-- Create materialized view for Shopify customer addresses
CREATE MATERIALIZED VIEW data_shopify.customer_addresses
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(updated_at)
ORDER BY (id, updated_at)
SETTINGS index_granularity = 8192
AS
SELECT 
    -- Core fields (non-PII only)
    id,
    customer_id,
    country,
    country_code,
    country_name,
    province,
    province_code,
    default,
    shop_url,
    updated_at
    
FROM raw_shopify.customer_address
WHERE id IS NOT NULL 
  AND updated_at IS NOT NULL;