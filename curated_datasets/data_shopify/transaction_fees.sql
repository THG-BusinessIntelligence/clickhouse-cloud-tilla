-- Transaction fees flattened table
-- Extracts fee details from transactions
CREATE VIEW data_shopify.transaction_fees
AS
SELECT 
    id AS transaction_id,
    order_id,
    
    -- Fee details extracted from fees JSON
    JSONExtractFloat(fees, 'amount') AS fee_amount,
    JSONExtractString(fees, 'currency') AS fee_currency,
    JSONExtractString(fees, 'type') AS fee_type,
    JSONExtractString(fees, 'gateway') AS fee_gateway,
    JSONExtractFloat(fees, 'percentage') AS fee_percentage,
    
    -- Context
    gateway AS transaction_gateway,
    kind AS transaction_kind,
    created_at AS transaction_created_at,
    shop_url
    
FROM raw_shopify.transactions
WHERE id IS NOT NULL 
  AND fees IS NOT NULL
  AND length(fees) > 2; -- Ensure fees JSON is not empty