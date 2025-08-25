-- Backfill historical data for countries
INSERT INTO data_shopify.countries
SELECT 
    -- Core fields
    id,
    code,
    name,
    shop_url,
    rest_of_world
FROM raw_shopify.countries
WHERE id IS NOT NULL;