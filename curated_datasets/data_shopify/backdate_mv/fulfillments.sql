-- Backfill fulfillments main table
INSERT INTO data_shopify.fulfillments
SELECT 
    -- Core fields
    id,
    name,
    status,
    service,
    shop_url,
    created_at,
    updated_at,
    location_id,
    order_id,
    
    -- Tracking info
    tracking_company,
    if(isNull(tracking_numbers), [], JSONExtractArrayRaw(assumeNotNull(tracking_numbers))) as tracking_numbers_array,
    if(isNull(tracking_urls), [], JSONExtractArrayRaw(assumeNotNull(tracking_urls))) as tracking_urls_array,
    
    -- Shipment details
    shipment_status,
    notify_customer,
    
    -- Line items summary
    if(isNull(line_items), 0, length(JSONExtractArrayRaw(assumeNotNull(line_items)))) as line_items_count,
    
    -- Gift cards count from receipt
    if(isNull(receipt), 0, length(JSONExtractArrayRaw(assumeNotNull(receipt), 'gift_cards'))) as gift_cards_count,
    
    -- Other fields
    duties,
    origin_address,
    tracking_url,
    tracking_number,
    admin_graphql_api_id,
    variant_inventory_management
    
FROM raw_shopify.fulfillments
WHERE id IS NOT NULL 
  AND updated_at IS NOT NULL;