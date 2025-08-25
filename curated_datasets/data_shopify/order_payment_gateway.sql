CREATE MATERIALIZED VIEW IF NOT EXISTS data_shopify.order_payment_gateways
ENGINE = MergeTree()
PARTITION BY toYYYYMM(assumeNotNull(created_at))
ORDER BY (order_id, gateway_name)
POPULATE
AS
SELECT
    id AS order_id,
    created_at,
    arrayJoin(JSONExtractArrayRaw(assumeNotNull(payment_gateway_names))) AS gateway_name_json,
    JSONExtractString(gateway_name_json) AS gateway_name
FROM raw_shopify.orders
WHERE 
    payment_gateway_names IS NOT NULL
    AND length(payment_gateway_names) > 0;
