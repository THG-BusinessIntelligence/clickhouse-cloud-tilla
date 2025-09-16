-- Materialized View for Shopify discount codes
CREATE MATERIALIZED VIEW data_shopify.discount_codes
ENGINE = MergeTree()
ORDER BY (id, updated_at)
AS
SELECT 
    -- Core fields
    id,
    code,
    title,
    status,
    typename,
    shop_url,
    created_at,
    updated_at,
    starts_at,
    ends_at,
    
    -- Usage metrics
    usage_count,
    usage_limit,
    async_usage_count,
    
    -- Extract from JSON fields
    JSONExtractInt(codes_count, 'count') as codes_count,
    JSONExtractFloat(total_sales, 'amount') as total_sales_amount,
    JSONExtractString(total_sales, 'currency_code') as total_sales_currency,
    
    -- Other fields
    discount_type,
    price_rule_id,
    admin_graphql_api_id,
    applies_once_per_customer,
    summary,
    createdBy
    
FROM raw_shopify.discount_codes
WHERE id IS NOT NULL 
  AND updated_at IS NOT NULL;