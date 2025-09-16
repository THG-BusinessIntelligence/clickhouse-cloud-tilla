-- Materialized View for fulfillment line items
CREATE MATERIALIZED VIEW data_shopify.fulfillment_line_items
ENGINE = MergeTree()
ORDER BY (fulfillment_id, line_item_id)
AS
SELECT
    id as fulfillment_id,
    updated_at as fulfillment_updated_at,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'id') as line_item_id,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'admin_graphql_api_id') as admin_graphql_api_id,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'product_id') as product_id,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'variant_id') as variant_id,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'sku') as sku,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'name') as name,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'title') as title,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'variant_title') as variant_title,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'vendor') as vendor,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'quantity') as quantity,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'current_quantity') as current_quantity,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'fulfillable_quantity') as fulfillable_quantity,
    JSONExtractFloat(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'price') as price,
    JSONExtractFloat(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'pre_tax_price') as pre_tax_price,
    JSONExtractFloat(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'total_discount') as total_discount,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'grams') as grams,
    JSONExtractBool(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'gift_card') as is_gift_card,
    JSONExtractBool(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'taxable') as is_taxable,
    JSONExtractBool(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'requires_shipping') as requires_shipping,
    JSONExtractBool(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'product_exists') as product_exists,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'fulfillment_service') as fulfillment_service,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'fulfillment_status') as fulfillment_status,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'variant_inventory_management') as variant_inventory_management
FROM raw_shopify.fulfillments
ARRAY JOIN arrayEnumerate(JSONExtractArrayRaw(assumeNotNull(line_items))) AS item_index
WHERE id IS NOT NULL
  AND line_items IS NOT NULL;