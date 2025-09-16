-- Create materialized view for Shopify price rules
-- Price rules define discount eligibility and configurations
CREATE MATERIALIZED VIEW data_shopify.price_rules
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(assumeNotNull(created_at))
ORDER BY (id, assumeNotNull(updated_at))
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    -- Core fields
    id AS price_rule_id,
    title,
    value,
    value_type,  -- fixed_amount, percentage
    
    -- Target configuration
    target_type,  -- line_item, shipping_line
    target_selection,  -- all, entitled
    
    -- Allocation settings
    allocation_method,  -- across, each
    allocation_limit,
    
    -- Customer settings
    customer_selection,  -- all, prerequisite
    once_per_customer,
    
    -- Usage settings
    usage_limit,
    
    -- Time bounds
    starts_at,
    ends_at,
    
    -- Timestamps
    created_at,
    updated_at,
    deleted_at,
    
    -- Prerequisites (JSON arrays - extract counts for reporting)
    if(isNull(prerequisite_product_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(prerequisite_product_ids)))) AS prerequisite_products_count,
    if(isNull(prerequisite_variant_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(prerequisite_variant_ids)))) AS prerequisite_variants_count,
    if(isNull(prerequisite_collection_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(prerequisite_collection_ids)))) AS prerequisite_collections_count,
    if(isNull(prerequisite_customer_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(prerequisite_customer_ids)))) AS prerequisite_customers_count,
    
    -- Entitled items (JSON arrays - extract counts)
    if(isNull(entitled_product_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(entitled_product_ids)))) AS entitled_products_count,
    if(isNull(entitled_variant_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(entitled_variant_ids)))) AS entitled_variants_count,
    if(isNull(entitled_collection_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(entitled_collection_ids)))) AS entitled_collections_count,
    if(isNull(entitled_country_ids), 0, 
       length(JSONExtractArrayRaw(assumeNotNull(entitled_country_ids)))) AS entitled_countries_count,
    
    -- Prerequisites ranges (extract from JSON)
    JSONExtractFloat(prerequisite_quantity_range, 'greater_than_or_equal_to') AS min_quantity,
    JSONExtractFloat(prerequisite_subtotal_range, 'greater_than_or_equal_to') AS min_subtotal,
    JSONExtractFloat(prerequisite_shipping_price_range, 'less_than_or_equal_to') AS max_shipping_price,
    
    -- Ratio for BOGO type rules
    JSONExtractFloat(prerequisite_to_entitlement_quantity_ratio, 'prerequisite_quantity') AS prerequisite_quantity,
    JSONExtractFloat(prerequisite_to_entitlement_quantity_ratio, 'entitled_quantity') AS entitled_quantity,
    
    -- Other fields
    shop_url,
    admin_graphql_api_id
    
FROM raw_shopify.price_rules
WHERE id IS NOT NULL;