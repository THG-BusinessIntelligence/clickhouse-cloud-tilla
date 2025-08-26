-- Shopify transactions core table
-- Financial operations (payments, refunds, etc.) for orders
-- Simplified view with separate tables for nested data
CREATE VIEW data_shopify.transactions
AS
SELECT
    -- Core transaction fields
    id AS transaction_id,
    order_id,
    parent_id AS parent_transaction_id,
    
    -- Transaction details
    kind AS transaction_kind,  -- sale, refund, authorization, capture, void
    status AS transaction_status,  -- success, failure, pending, error
    gateway,
    amount,
    currency,
    
    -- Extract amount_set JSON (presentment and shop money amounts)
    JSONExtractFloat(amount_set, 'shop_money', 'amount') AS amount_shop_money,
    JSONExtractString(amount_set, 'shop_money', 'currency_code') AS shop_currency,
    JSONExtractFloat(amount_set, 'presentment_money', 'amount') AS amount_presentment_money,
    JSONExtractString(amount_set, 'presentment_money', 'currency_code') AS presentment_currency,
    
    -- Processing information
    created_at,
    processed_at,
    authorization,
    message,
    error_code,
    
    -- Location and context
    shop_url,
    location_id,
    source_name,
    user_id,
    device_id,
    
    -- Payment ID
    payment_id,
    
    -- Total unsettled amount
    JSONExtractFloat(total_unsettled_set, 'shop_money', 'amount') AS total_unsettled_amount,
    
    -- Additional fields
    test,
    manuallyCapturable AS manually_capturable,
    admin_graphql_api_id,
    
    -- Flags for joins with flattened tables
    CASE WHEN fees IS NOT NULL AND length(fees) > 2 THEN 1 ELSE 0 END AS has_fees,
    CASE WHEN payment_details IS NOT NULL AND length(payment_details) > 2 THEN 1 ELSE 0 END AS has_payment_details,
    CASE WHEN receipt IS NOT NULL AND length(receipt) > 2 THEN 1 ELSE 0 END AS has_receipt
    
FROM raw_shopify.transactions
WHERE id IS NOT NULL
  AND order_id IS NOT NULL;