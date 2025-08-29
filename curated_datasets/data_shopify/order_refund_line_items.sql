-- Materialized View for Shopify order refund line items
CREATE MATERIALIZED VIEW data_shopify.order_refund_line_items
ENGINE = MergeTree()
ORDER BY (refund_id, line_item_id)
AS
SELECT
    -- Refund level fields
    id AS refund_id,
    order_id,
    shop_url,
    created_at,
    processed_at,
    admin_graphql_api_id AS refund_admin_graphql_api_id,
    
    -- Refund line item fields
    JSONExtractInt(line_item_json, 'id') AS refund_line_item_id,
    JSONExtractInt(line_item_json, 'line_item_id') AS line_item_id,
    JSONExtractInt(line_item_json, 'location_id') AS location_id,
    JSONExtractInt(line_item_json, 'quantity') AS quantity,
    JSONExtractString(line_item_json, 'restock_type') AS restock_type,
    JSONExtractFloat(line_item_json, 'subtotal') AS subtotal,
    JSONExtractFloat(line_item_json, 'total_tax') AS total_tax,
    
    -- Subtotal set fields - using MULTI-PARAMETER SYNTAX
    JSONExtractFloat(line_item_json, 'subtotal_set', 'shop_money', 'amount') AS subtotal_shop_money_amount,
    JSONExtractString(line_item_json, 'subtotal_set', 'shop_money', 'currency_code') AS currency_code,
    
    -- Line item details - using MULTI-PARAMETER SYNTAX
    JSONExtractString(line_item_json, 'line_item', 'admin_graphql_api_id') AS line_item_admin_graphql_api_id,
    JSONExtractInt(line_item_json, 'line_item', 'current_quantity') AS current_quantity,
    JSONExtractInt(line_item_json, 'line_item', 'fulfillable_quantity') AS fulfillable_quantity,
    JSONExtractString(line_item_json, 'line_item', 'fulfillment_status') AS fulfillment_status,
    JSONExtractBool(line_item_json, 'line_item', 'gift_card') AS gift_card,
    JSONExtractInt(line_item_json, 'line_item', 'grams') AS grams,
    JSONExtractString(line_item_json, 'line_item', 'name') AS name,
    JSONExtractFloat(line_item_json, 'line_item', 'price') AS price,
    JSONExtractInt(line_item_json, 'line_item', 'product_id') AS product_id,
    JSONExtractString(line_item_json, 'line_item', 'sku') AS sku,
    JSONExtractString(line_item_json, 'line_item', 'title') AS title,
    JSONExtractFloat(line_item_json, 'line_item', 'total_discount') AS total_discount,
    JSONExtractInt(line_item_json, 'line_item', 'variant_id') AS variant_id,
    JSONExtractString(line_item_json, 'line_item', 'variant_title') AS variant_title,
    JSONExtractString(line_item_json, 'line_item', 'vendor') AS vendor,
    JSONExtractBool(line_item_json, 'line_item', 'taxable') AS taxable,
    JSONExtractBool(line_item_json, 'line_item', 'product_exists') AS product_exists,
    JSONExtractBool(line_item_json, 'line_item', 'requires_shipping') AS requires_shipping
    
FROM raw_shopify.order_refunds
ARRAY JOIN 
    JSONExtractArrayRaw(assumeNotNull(refund_line_items)) AS line_item_json
WHERE 
    refund_line_items IS NOT NULL
    AND length(refund_line_items) > 0;