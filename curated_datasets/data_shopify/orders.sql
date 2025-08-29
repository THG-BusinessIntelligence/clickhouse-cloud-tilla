-- Shopify orders core table
-- Simplified materialized view with separate tables for nested data
CREATE MATERIALIZED VIEW data_shopify.orders
ENGINE = MergeTree()
ORDER BY (order_id, created_at)
AS
SELECT
    -- Primary key
    id AS order_id,
    
    -- Order identifiers
    number AS order_number,
    name AS order_name,
    order_number AS display_order_number,
    
    -- Status fields
    financial_status,
    fulfillment_status,
    confirmed,
    test,
    
    -- Timestamps
    created_at,
    updated_at,
    parseDateTime64BestEffort(processed_at) AS processed_at,
    closed_at,
    cancelled_at,
    
    -- Customer info (extract from hashed customer JSON - only ID, no PII)
    JSONExtractInt(customer_hashed, 'id') AS customer_id,
    buyer_accepts_marketing,
    customer_locale,
    
    -- Location references (foreign keys)
    shop_url,
    location_id,
    
    -- Checkout information
    checkout_id,
    cart_token,
    checkout_token,
    
    -- Source tracking
    source_name,
    source_identifier,
    device_id,
    landing_site,
    landing_site_ref,
    referring_site,
    
    -- Financial summary
    currency,
    presentment_currency,
    total_price,
    subtotal_price,
    total_tax,
    total_discounts,
    total_weight,
    total_line_items_price,
    total_price_usd,
    total_outstanding,
    total_tip_received,
    
    -- Current totals (for partially refunded orders)
    current_total_price,
    current_subtotal_price,
    current_total_tax,
    current_total_discounts,
    
    -- Extract price set data for multi-currency
    JSONExtractFloat(total_price_set, 'shop_money', 'amount') AS total_price_shop_money,
    JSONExtractFloat(total_price_set, 'presentment_money', 'amount') AS total_price_presentment_money,
    JSONExtractFloat(subtotal_price_set, 'shop_money', 'amount') AS subtotal_price_shop_money,
    JSONExtractFloat(subtotal_price_set, 'presentment_money', 'amount') AS subtotal_price_presentment_money,
    
    -- Tax settings
    taxes_included,
    tax_exempt,
    estimated_taxes,
    duties_included,
    
    -- Extract total tax set
    JSONExtractFloat(total_tax_set, 'shop_money', 'amount') AS total_tax_shop_money,
    JSONExtractFloat(total_tax_set, 'presentment_money', 'amount') AS total_tax_presentment_money,
    
    -- App and merchant references
    app_id,
    user_id,
    merchant_of_record_app_id,
    merchant_business_entity_id,
    
    -- Cancellation info
    cancel_reason,
    
    -- Tags and notes
    tags,
    po_number,
    company,
    reference,
    
    -- Count of related records for quick reporting
    if(isNull(line_items), 0, length(JSONExtractArrayRaw(assumeNotNull(line_items)))) AS line_items_count,
    if(isNull(refunds), 0, length(JSONExtractArrayRaw(assumeNotNull(refunds)))) AS refunds_count,
    if(isNull(fulfillments), 0, length(JSONExtractArrayRaw(assumeNotNull(fulfillments)))) AS fulfillments_count,
    if(isNull(discount_codes), 0, length(JSONExtractArrayRaw(assumeNotNull(discount_codes)))) AS discount_codes_count,
    if(isNull(tax_lines), 0, length(JSONExtractArrayRaw(assumeNotNull(tax_lines)))) AS tax_lines_count,
    
    -- Payment gateway names (extract as array for reporting)
    if(isNull(payment_gateway_names), [], JSONExtractArrayRaw(assumeNotNull(payment_gateway_names))) AS payment_gateways,
    
    -- Flags for joins with flattened tables
    CASE WHEN discount_applications IS NOT NULL AND length(discount_applications) > 2 THEN 1 ELSE 0 END AS has_discount_applications,
    CASE WHEN note_attributes IS NOT NULL AND length(note_attributes) > 2 THEN 1 ELSE 0 END AS has_note_attributes,
    CASE WHEN payment_terms IS NOT NULL AND length(payment_terms) > 2 THEN 1 ELSE 0 END AS has_payment_terms,
    
    -- Admin API ID
    admin_graphql_api_id
    
FROM raw_shopify.orders
WHERE id IS NOT NULL;