CREATE MATERIALIZED VIEW IF NOT EXISTS data_shopify.orders
ENGINE = MergeTree()
PARTITION BY toYYYYMM(assumeNotNull(created_at))
ORDER BY (order_id, assumeNotNull(created_at))
POPULATE
AS
SELECT
    id AS order_id,
    any(number) AS order_number,
    any(name) AS order_name,
    any(financial_status) AS financial_status,
    any(fulfillment_status) AS fulfillment_status,
    any(confirmed) AS confirmed,
    any(test) AS test,
    any(created_at) AS created_at,
    any(updated_at) AS updated_at,
    any(parseDateTime64BestEffort(processed_at)) AS processed_at,
    any(closed_at) AS closed_at,
    any(cancelled_at) AS cancelled_at,
    any(shop_url) AS shop_url,
    any(location_id) AS location_id,
    any(checkout_id) AS checkout_id,
    any(cart_token) AS cart_token,
    any(checkout_token) AS checkout_token,
    any(source_name) AS source_name,
    any(currency) AS currency,
    any(presentment_currency) AS presentment_currency,
    any(total_price) AS total_price,
    any(subtotal_price) AS subtotal_price,
    any(total_tax) AS total_tax,
    any(total_discounts) AS total_discounts,
    any(total_weight) AS total_weight,
    any(total_line_items_price) AS total_line_items_price,
    any(total_price_usd) AS total_price_usd,
    any(total_outstanding) AS total_outstanding,
    any(total_tip_received) AS total_tip_received,
    any(current_total_price) AS current_total_price,
    any(current_subtotal_price) AS current_subtotal_price,
    any(current_total_tax) AS current_total_tax,
    any(current_total_discounts) AS current_total_discounts,
    any(taxes_included) AS taxes_included,
    any(buyer_accepts_marketing) AS buyer_accepts_marketing,
    any(tax_exempt) AS tax_exempt,
    any(estimated_taxes) AS estimated_taxes,
    any(app_id) AS app_id,
    any(cancel_reason) AS cancel_reason,
    any(admin_graphql_api_id) AS admin_graphql_api_id
FROM raw_shopify.orders
WHERE id IS NOT NULL
GROUP BY id;