-- Backfill fulfillment line items
INSERT INTO data_shopify.fulfillment_line_items
WITH line_items_expanded AS (
    SELECT 
        id as fulfillment_id,
        updated_at as fulfillment_updated_at,
        arrayJoin(
            arrayEnumerate(JSONExtractArrayRaw(assumeNotNull(line_items)))
        ) as item_index,
        JSONExtractArrayRaw(assumeNotNull(line_items)) as items_array
    FROM raw_shopify.fulfillments
    WHERE id IS NOT NULL 
      AND line_items IS NOT NULL
)
SELECT 
    fulfillment_id,
    fulfillment_updated_at,
    JSONExtractInt(items_array[item_index], 'id') as line_item_id,
    JSONExtractString(items_array[item_index], 'admin_graphql_api_id') as admin_graphql_api_id,
    JSONExtractInt(items_array[item_index], 'product_id') as product_id,
    JSONExtractInt(items_array[item_index], 'variant_id') as variant_id,
    JSONExtractString(items_array[item_index], 'sku') as sku,
    JSONExtractString(items_array[item_index], 'name') as name,
    JSONExtractString(items_array[item_index], 'title') as title,
    JSONExtractString(items_array[item_index], 'variant_title') as variant_title,
    JSONExtractString(items_array[item_index], 'vendor') as vendor,
    JSONExtractInt(items_array[item_index], 'quantity') as quantity,
    JSONExtractInt(items_array[item_index], 'current_quantity') as current_quantity,
    JSONExtractInt(items_array[item_index], 'fulfillable_quantity') as fulfillable_quantity,
    JSONExtractFloat(items_array[item_index], 'price') as price,
    JSONExtractFloat(items_array[item_index], 'pre_tax_price') as pre_tax_price,
    JSONExtractFloat(items_array[item_index], 'total_discount') as total_discount,
    JSONExtractInt(items_array[item_index], 'grams') as grams,
    JSONExtractBool(items_array[item_index], 'gift_card') as is_gift_card,
    JSONExtractBool(items_array[item_index], 'taxable') as is_taxable,
    JSONExtractBool(items_array[item_index], 'requires_shipping') as requires_shipping,
    JSONExtractBool(items_array[item_index], 'product_exists') as product_exists,
    JSONExtractString(items_array[item_index], 'fulfillment_service') as fulfillment_service,
    JSONExtractString(items_array[item_index], 'fulfillment_status') as fulfillment_status,
    JSONExtractString(items_array[item_index], 'variant_inventory_management') as variant_inventory_management
FROM line_items_expanded;