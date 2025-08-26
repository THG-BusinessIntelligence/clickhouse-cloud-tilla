-- View for Shopify customer address
CREATE VIEW data_shopify.customer_address
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
    "default" AS is_default,  -- Aliasing 'default' as it's a reserved keyword
    shop_url,
    updated_at
    
FROM raw_shopify.customer_address
WHERE id IS NOT NULL 
  AND updated_at IS NOT NULL;