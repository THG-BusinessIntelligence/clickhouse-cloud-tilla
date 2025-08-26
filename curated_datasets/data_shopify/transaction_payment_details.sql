-- Transaction payment details flattened table
-- Extracts payment card and method details from transactions
CREATE VIEW data_shopify.transaction_payment_details
AS
SELECT 
    id AS transaction_id,
    order_id,
    
    -- Payment details extracted from payment_details JSON
    JSONExtractString(payment_details, 'credit_card_company') AS credit_card_company,
    JSONExtractString(payment_details, 'credit_card_wallet') AS credit_card_wallet,
    JSONExtractString(payment_details, 'credit_card_bin') AS credit_card_bin,
    JSONExtractString(payment_details, 'avs_result_code') AS avs_result_code,
    JSONExtractString(payment_details, 'cvv_result_code') AS cvv_result_code,
    JSONExtractString(payment_details, 'credit_card_number') AS credit_card_number_masked,
    JSONExtractString(payment_details, 'credit_card_name') AS cardholder_name_masked,
    JSONExtractString(payment_details, 'payment_method') AS payment_method,
    
    -- Context
    gateway AS transaction_gateway,
    kind AS transaction_kind,
    status AS transaction_status,
    created_at AS transaction_created_at,
    shop_url
    
FROM raw_shopify.transactions
WHERE id IS NOT NULL 
  AND payment_details IS NOT NULL
  AND length(payment_details) > 2; -- Ensure payment_details JSON is not empty