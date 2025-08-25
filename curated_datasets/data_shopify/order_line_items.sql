CREATE MATERIALIZED VIEW IF NOT EXISTS data_shopify.order_line_items
ENGINE = MergeTree()
PARTITION BY toYYYYMM(assumeNotNull(order_created_at))
ORDER BY (order_id, line_item_id)
POPULATE
AS
SELECT
    -- Order reference
    id AS order_id,
    created_at AS order_created_at,
    currency AS order_currency,
    financial_status,
    fulfillment_status,
    
    -- Line item fields
    JSONExtractInt(line_item_json, 'id') AS line_item_id,
    JSONExtractString(line_item_json, 'admin_graphql_api_id') AS line_item_admin_graphql_api_id,
    
    -- Product info
    JSONExtractInt(line_item_json, 'product_id') AS product_id,
    JSONExtractInt(line_item_json, 'variant_id') AS variant_id,
    JSONExtractString(line_item_json, 'sku') AS sku,
    JSONExtractString(line_item_json, 'name') AS product_name,
    JSONExtractString(line_item_json, 'title') AS product_title,
    JSONExtractString(line_item_json, 'variant_title') AS variant_title,
    JSONExtractString(line_item_json, 'vendor') AS vendor,
    
    -- Quantities and fulfillment
    JSONExtractInt(line_item_json, 'quantity') AS quantity,
    JSONExtractInt(line_item_json, 'current_quantity') AS current_quantity,
    JSONExtractInt(line_item_json, 'fulfillable_quantity') AS fulfillable_quantity,
    JSONExtractString(line_item_json, 'fulfillment_status') AS line_fulfillment_status,
    JSONExtractString(line_item_json, 'fulfillment_service') AS fulfillment_service,
    
    -- Pricing
    JSONExtractFloat(line_item_json, 'price') AS price,
    JSONExtractFloat(line_item_json, 'pre_tax_price') AS pre_tax_price,
    JSONExtractFloat(line_item_json, 'total_discount') AS total_discount,
    
    -- Product attributes
    JSONExtractInt(line_item_json, 'grams') AS grams,
    JSONExtractBool(line_item_json, 'gift_card') AS gift_card,
    JSONExtractBool(line_item_json, 'taxable') AS taxable,
    JSONExtractBool(line_item_json, 'product_exists') AS product_exists,
    JSONExtractBool(line_item_json, 'requires_shipping') AS requires_shipping,
    
    -- Amounts from nested objects
    JSONExtractFloat(line_item_json, 'price_set', 'shop_money', 'amount') AS price_shop_money,
    JSONExtractFloat(line_item_json, 'pre_tax_price_set', 'shop_money', 'amount') AS pre_tax_price_shop_money,
    JSONExtractFloat(line_item_json, 'total_discount_set', 'shop_money', 'amount') AS total_discount_shop_money
    
FROM raw_shopify.orders
ARRAY JOIN 
    JSONExtractArrayRaw(assumeNotNull(line_items)) AS line_item_json
WHERE 
    line_items IS NOT NULL
    AND length(line_items) > 0;
