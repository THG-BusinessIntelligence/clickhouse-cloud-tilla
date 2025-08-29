-- Materialized View for Shopify inventory items
CREATE MATERIALIZED VIEW data_shopify.inventory_items
ENGINE = MergeTree()
ORDER BY (id, updated_at)
AS SELECT
    id,
    sku,
    cost,
    tracked,
    shop_url,
    created_at,
    updated_at,
    currency_code,
    requires_shipping,
    duplicate_sku_count,
    admin_graphql_api_id,
    country_code_of_origin,
    harmonized_system_code,
    province_code_of_origin,
    country_harmonized_system_codes
FROM raw_shopify.inventory_items;