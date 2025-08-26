-- View for Shopify order refund transactions
CREATE VIEW data_shopify.order_refund_transactions
AS
SELECT
    -- Refund level fields
    id AS refund_id,
    order_id,
    shop_url,
    created_at,
    processed_at,
    restock,
    note,
    admin_graphql_api_id AS refund_admin_graphql_api_id,
    
    -- Transaction level fields
    JSONExtractInt(transaction_json, 'id') AS transaction_id,
    JSONExtractString(transaction_json, 'admin_graphql_api_id') AS transaction_admin_graphql_api_id,
    JSONExtractFloat(transaction_json, 'amount') AS amount,
    JSONExtractString(transaction_json, 'authorization') AS authorization,
    parseDateTime64BestEffort(JSONExtractString(transaction_json, 'created_at')) AS transaction_created_at,
    JSONExtractString(transaction_json, 'currency') AS currency,
    JSONExtractString(transaction_json, 'gateway') AS gateway,
    JSONExtractString(transaction_json, 'kind') AS kind,
    JSONExtractString(transaction_json, 'message') AS message,
    JSONExtractInt(transaction_json, 'parent_id') AS parent_id,
    JSONExtractString(transaction_json, 'payment_id') AS payment_id,
    parseDateTime64BestEffort(JSONExtractString(transaction_json, 'processed_at')) AS transaction_processed_at,
    JSONExtractString(transaction_json, 'source_name') AS source_name,
    JSONExtractString(transaction_json, 'status') AS status,
    JSONExtractBool(transaction_json, 'test') AS test,
    
    -- Payment details - using MULTI-PARAMETER SYNTAX
    JSONExtractString(transaction_json, 'payment_details', 'credit_card_company') AS credit_card_company,
    JSONExtractString(transaction_json, 'payment_details', 'payment_method_name') AS payment_method_name
    
FROM raw_shopify.order_refunds
ARRAY JOIN
    JSONExtractArrayRaw(assumeNotNull(transactions)) AS transaction_json
WHERE
    transactions IS NOT NULL
    AND length(transactions) > 0;
