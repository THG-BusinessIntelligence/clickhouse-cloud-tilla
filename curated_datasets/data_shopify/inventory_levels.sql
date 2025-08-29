-- Materialized View for Shopify inventory levels
CREATE MATERIALIZED VIEW data_shopify.inventory_levels
ENGINE = MergeTree()
ORDER BY (id, inventory_item_id, location_id)
AS SELECT
    id,
    shop_url,
    available,
    created_at,
    updated_at,
    location_id,
    can_deactivate,
    inventory_item_id,
    deactivation_alert,
    admin_graphql_api_id,
    inventory_history_url
FROM raw_shopify.inventory_levels;