-- View for Shopify order payment gateways
CREATE VIEW data_shopify.order_payment_gateways
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
