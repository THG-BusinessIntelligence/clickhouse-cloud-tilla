-- View for abandoned checkout line items
CREATE VIEW data_shopify.abandoned_checkouts_line_items
AS
SELECT
    id as checkout_id,
    updated_at as checkout_updated_at,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'id') as line_item_id,
    item_index as position,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'product_id') as product_id,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'variant_id') as variant_id,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'sku') as sku,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'title') as title,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'variant_title') as variant_title,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'vendor') as vendor,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'quantity') as quantity,
    JSONExtractFloat(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'price') as price,
    JSONExtractFloat(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'line_price') as line_price,
    JSONExtractInt(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'grams') as grams,
    JSONExtractBool(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'gift_card') as is_gift_card,
    JSONExtractBool(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'taxable') as is_taxable,
    JSONExtractBool(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'requires_shipping') as requires_shipping,
    JSONExtractString(arrayElement(JSONExtractArrayRaw(assumeNotNull(line_items)), item_index), 'fulfillment_service') as fulfillment_service
FROM raw_shopify.abandoned_checkouts
ARRAY JOIN arrayEnumerate(JSONExtractArrayRaw(assumeNotNull(line_items))) AS item_index
WHERE id IS NOT NULL
  AND line_items IS NOT NULL;