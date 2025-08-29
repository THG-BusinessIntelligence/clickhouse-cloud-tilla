-- Materialized View for Shopify order tax lines
CREATE MATERIALIZED VIEW data_shopify.order_tax_lines
ENGINE = MergeTree()
ORDER BY (order_id, line_item_id)
AS
SELECT
    -- Order reference
    id AS order_id,
    created_at AS order_created_at,
    
    -- Line item reference
    JSONExtractInt(line_item_json, 'id') AS line_item_id,
    JSONExtractString(line_item_json, 'name') AS product_name,
    JSONExtractString(line_item_json, 'sku') AS sku,
    
    -- Tax details
    JSONExtractString(tax_json, 'title') AS tax_title,
    JSONExtractFloat(tax_json, 'rate') AS tax_rate,
    JSONExtractFloat(tax_json, 'price') AS tax_amount,
    JSONExtractBool(tax_json, 'channel_liable') AS channel_liable,
    
    -- Tax amounts from nested objects
    JSONExtractFloat(tax_json, 'price_set', 'shop_money', 'amount') AS tax_amount_shop_money,
    JSONExtractString(tax_json, 'price_set', 'shop_money', 'currency_code') AS currency_code
    
FROM raw_shopify.orders
ARRAY JOIN
    JSONExtractArrayRaw(assumeNotNull(line_items)) AS line_item_json
ARRAY JOIN
    JSONExtractArrayRaw(line_item_json, 'tax_lines') AS tax_json
WHERE
    line_items IS NOT NULL
    AND length(line_items) > 0
    AND JSONExtractArrayRaw(line_item_json, 'tax_lines') IS NOT NULL
