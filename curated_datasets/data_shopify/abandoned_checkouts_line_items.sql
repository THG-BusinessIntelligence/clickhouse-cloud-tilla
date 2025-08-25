-- Create materialized view for abandoned checkout line items
CREATE MATERIALIZED VIEW data_shopify.abandoned_checkouts_line_items
ENGINE = MergeTree()
ORDER BY (checkout_id, line_item_id, position)
SETTINGS index_granularity = 8192
AS
WITH line_items_expanded AS (
    SELECT 
        id as checkout_id,
        updated_at as checkout_updated_at,
        arrayJoin(
            arrayEnumerate(JSONExtractArrayRaw(assumeNotNull(line_items)))
        ) as item_index,
        JSONExtractArrayRaw(assumeNotNull(line_items)) as items_array
    FROM raw_shopify.abandoned_checkouts
    WHERE id IS NOT NULL 
      AND line_items IS NOT NULL
)
SELECT 
    checkout_id,
    checkout_updated_at,
    JSONExtractString(items_array[item_index], 'id') as line_item_id,
    item_index as position,
    JSONExtractInt(items_array[item_index], 'product_id') as product_id,
    JSONExtractInt(items_array[item_index], 'variant_id') as variant_id,
    JSONExtractString(items_array[item_index], 'sku') as sku,
    JSONExtractString(items_array[item_index], 'title') as title,
    JSONExtractString(items_array[item_index], 'variant_title') as variant_title,
    JSONExtractString(items_array[item_index], 'vendor') as vendor,
    JSONExtractInt(items_array[item_index], 'quantity') as quantity,
    JSONExtractFloat(items_array[item_index], 'price') as price,
    JSONExtractFloat(items_array[item_index], 'line_price') as line_price,
    JSONExtractInt(items_array[item_index], 'grams') as grams,
    JSONExtractBool(items_array[item_index], 'gift_card') as is_gift_card,
    JSONExtractBool(items_array[item_index], 'taxable') as is_taxable,
    JSONExtractBool(items_array[item_index], 'requires_shipping') as requires_shipping,
    JSONExtractString(items_array[item_index], 'fulfillment_service') as fulfillment_service
FROM line_items_expanded;