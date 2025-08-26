-- View for Shopify countries
CREATE VIEW data_shopify.countries
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