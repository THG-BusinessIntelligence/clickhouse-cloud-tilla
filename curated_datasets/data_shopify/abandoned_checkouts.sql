-- View for Shopify abandoned checkouts
CREATE VIEW data_shopify.abandoned_checkouts
AS
SELECT 
    -- Core fields
    id,
    token,
    source,
    gateway,
    user_id,
    currency,
    shop_url,
    closed_at,
    device_id,
    total_tax,
    cart_token,
    created_at,
    updated_at,
    location_id,
    source_name,
    total_price,
    completed_at,
    landing_site,
    total_weight,
    referring_site,
    subtotal_price,
    taxes_included,
    customer_locale,
    total_discounts,
    presentment_currency,
    abandoned_checkout_url,
    total_line_items_price,
    
    -- Summary metrics (handle nullable line_items)
    if(isNull(line_items), 0, length(JSONExtractArrayRaw(assumeNotNull(line_items)))) as line_items_count,
    if(isNull(line_items), 0, arraySum(arrayMap(x -> JSONExtractInt(x, 'quantity'), JSONExtractArrayRaw(assumeNotNull(line_items))))) as total_quantity,
    
    -- Tax summary (handle nullable tax_lines)
    if(isNull(tax_lines), NULL, JSONExtractFloat(assumeNotNull(tax_lines), 1, 'price')) as tax_amount,
    if(isNull(tax_lines), NULL, JSONExtractFloat(assumeNotNull(tax_lines), 1, 'rate')) as tax_rate,
    if(isNull(tax_lines), NULL, JSONExtractString(assumeNotNull(tax_lines), 1, 'title')) as tax_title,
    
    -- Discount summary (handle nullable discount_codes)
    if(isNull(discount_codes), NULL, JSONExtractString(assumeNotNull(discount_codes), 1, 'code')) as discount_code,
    if(isNull(discount_codes), NULL, JSONExtractString(assumeNotNull(discount_codes), 1, 'amount')) as discount_amount,
    if(isNull(discount_codes), NULL, JSONExtractString(assumeNotNull(discount_codes), 1, 'type')) as discount_type,
    
    -- Shipping summary (handle nullable shipping_lines)
    if(isNull(shipping_lines), NULL, JSONExtractString(assumeNotNull(shipping_lines), 1, 'code')) as shipping_code,
    if(isNull(shipping_lines), NULL, JSONExtractFloat(assumeNotNull(shipping_lines), 1, 'price')) as shipping_price,
    if(isNull(shipping_lines), NULL, JSONExtractString(assumeNotNull(shipping_lines), 1, 'title')) as shipping_title
    
FROM raw_shopify.abandoned_checkouts
WHERE id IS NOT NULL 
  AND updated_at IS NOT NULL;