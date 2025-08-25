CREATE MATERIALIZED VIEW IF NOT EXISTS data_shopify.order_discount_allocations
ENGINE = MergeTree()
PARTITION BY toYYYYMM(assumeNotNull(order_created_at))
ORDER BY (order_id, line_item_id, discount_application_index)
POPULATE
AS
SELECT
    -- Order reference
    id AS order_id,
    created_at AS order_created_at,
    
    -- Line item reference
    JSONExtractInt(line_item_json, 'id') AS line_item_id,
    JSONExtractString(line_item_json, 'name') AS product_name,
    JSONExtractString(line_item_json, 'sku') AS sku,
    
    -- Discount allocation details
    JSONExtractFloat(discount_json, 'amount') AS discount_amount,
    JSONExtractInt(discount_json, 'discount_application_index') AS discount_application_index,
    
    -- Discount amounts from nested objects
    JSONExtractFloat(discount_json, 'amount_set', 'shop_money', 'amount') AS discount_amount_shop_money,
    JSONExtractString(discount_json, 'amount_set', 'shop_money', 'currency_code') AS currency_code
    
FROM raw_shopify.orders
ARRAY JOIN 
    JSONExtractArrayRaw(assumeNotNull(line_items)) AS line_item_json
ARRAY JOIN
    JSONExtractArrayRaw(line_item_json, 'discount_allocations') AS discount_json
WHERE 
    line_items IS NOT NULL
    AND length(line_items) > 0
    AND JSONExtractArrayRaw(line_item_json, 'discount_allocations') IS NOT NULL;