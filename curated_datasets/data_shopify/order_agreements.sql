-- Flattened Order Agreements View
CREATE VIEW data_shopify.order_agreements_flattened
AS
SELECT
    -- Order level fields (excluding Airbyte metadata)
    id AS order_id,
    shop_url,
    created_at,
    updated_at,
    admin_graphql_api_id AS order_admin_graphql_api_id,
    
    -- Agreement level fields (from array)
    JSONExtractInt(agreement_json, 'id') AS agreement_id,
    parseDateTime64BestEffort(JSONExtractString(agreement_json, 'happened_at')) AS happened_at,
    JSONExtractString(agreement_json, 'reason') AS reason,
    JSONExtractString(agreement_json, 'admin_graphql_api_id') AS agreement_admin_graphql_api_id,
    
    -- Sale level fields (from nested array)
    JSONExtractInt(sale_json, 'id') AS sale_id,
    JSONExtractInt(sale_json, 'quantity') AS quantity,
    JSONExtractString(sale_json, 'action_type') AS action_type,
    JSONExtractString(sale_json, 'line_type') AS line_type,
    JSONExtractString(sale_json, 'admin_graphql_api_id') AS sale_admin_graphql_api_id,
    
    -- Line item fields
    JSONExtractInt(sale_json, 'line_item.id') AS line_item_id,
    JSONExtractString(sale_json, 'line_item.admin_graphql_api_id') AS line_item_admin_graphql_api_id,
    
    -- Amount fields (extracting from nested shop_money structure)
    JSONExtractFloat(sale_json, 'total_amount.shop_money.amount') AS total_amount,
    JSONExtractString(sale_json, 'total_amount.shop_money.currency_code') AS currency_code,
    JSONExtractFloat(sale_json, 'total_discount_amount_after_taxes.shop_money.amount') AS total_discount_amount_after_taxes,
    JSONExtractFloat(sale_json, 'total_discount_amount_before_taxes.shop_money.amount') AS total_discount_amount_before_taxes,
    JSONExtractFloat(sale_json, 'total_tax_amount.shop_money.amount') AS total_tax_amount
    
FROM raw_shopify.order_agreements
ARRAY JOIN
    JSONExtractArrayRaw(assumeNotNull(agreements)) AS agreement_json
ARRAY JOIN
    JSONExtractArrayRaw(agreement_json, 'sales') AS sale_json
WHERE
    agreements IS NOT NULL
    AND length(agreements) > 0;