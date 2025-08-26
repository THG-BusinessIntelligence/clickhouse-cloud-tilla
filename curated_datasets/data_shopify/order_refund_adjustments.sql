-- View for Shopify order refund adjustments
CREATE VIEW data_shopify.order_refund_adjustments
AS
SELECT
    -- Refund level fields
    id AS refund_id,
    order_id,
    shop_url,
    created_at,
    processed_at,
    admin_graphql_api_id AS refund_admin_graphql_api_id,
    
    -- Adjustment level fields
    JSONExtractInt(adjustment_json, 'id') AS adjustment_id,
    JSONExtractFloat(adjustment_json, 'amount') AS amount,
    JSONExtractString(adjustment_json, 'kind') AS kind,
    JSONExtractString(adjustment_json, 'reason') AS reason,
    
    -- Amount set fields - using MULTI-PARAMETER SYNTAX
    JSONExtractFloat(adjustment_json, 'amount_set', 'shop_money', 'amount') AS shop_money_amount,
    JSONExtractString(adjustment_json, 'amount_set', 'shop_money', 'currency_code') AS currency_code,
    
    -- Tax amount fields
    JSONExtractFloat(adjustment_json, 'tax_amount') AS tax_amount,
    JSONExtractFloat(adjustment_json, 'tax_amount_set', 'shop_money', 'amount') AS tax_shop_money_amount
    
FROM raw_shopify.order_refunds
ARRAY JOIN
    JSONExtractArrayRaw(assumeNotNull(order_adjustments)) AS adjustment_json
WHERE
    order_adjustments IS NOT NULL
    AND length(order_adjustments) > 0;