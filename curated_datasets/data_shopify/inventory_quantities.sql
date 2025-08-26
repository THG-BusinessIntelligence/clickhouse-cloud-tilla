
-- View for Shopify inventory quantities
CREATE VIEW data_shopify.inventory_quantities
AS SELECT
    id,
    JSONExtractString(quantity_item, 'name') AS quantity_name,
    JSONExtractFloat(quantity_item, 'quantity') AS quantity_value,
    JSONExtractString(quantity_item, 'updatedAt') AS quantity_updated_at,
    JSONExtractString(quantity_item, 'admin_graphql_api_id') AS quantity_admin_graphql_api_id
FROM raw_shopify.inventory_levels
ARRAY JOIN JSONExtractArrayRaw(ifNull(quantities, '[]')) AS quantity_item