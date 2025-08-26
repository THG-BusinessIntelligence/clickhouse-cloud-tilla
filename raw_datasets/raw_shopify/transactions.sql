CREATE TABLE raw_shopify.transactions
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `fees` Nullable(String),
    `kind` Nullable(String),
    `test` Nullable(Bool),
    `amount` Nullable(Decimal(38, 9)),
    `status` Nullable(String),
    `gateway` Nullable(String),
    `message` Nullable(String),
    `receipt` Nullable(String),
    `user_id` Nullable(Int64),
    `currency` Nullable(String),
    `order_id` Nullable(Int64),
    `shop_url` Nullable(String),
    `device_id` Nullable(Int64),
    `parent_id` Nullable(Int64),
    `amount_set` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `error_code` Nullable(String),
    `payment_id` Nullable(String),
    `location_id` Nullable(Int64),
    `source_name` Nullable(String),
    `processed_at` Nullable(DateTime64(3)),
    `accountNumber` Nullable(Int64),
    `authorization` Nullable(String),
    `payment_details` Nullable(String),
    `formattedGateway` Nullable(String),
    `manuallyCapturable` Nullable(Bool),
    `total_unsettled_set` Nullable(String),
    `admin_graphql_api_id` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192



----- Nested JSON Field Example Data ------ 

fees: 
[{"id":2933191115100,"rate":0.013,"type":"processing_fee","flat_fee_name":null,"rate_name":"domestic_card_not_present","amount":{"amount":0.52,"currency":"GBP"},"flat_fee":{"amount":0.25,"currency":"GBP"},"tax_amount":{"amount":0,"currency":"GBP"},"admin_graphql_api_id":"gid://shopify/TransactionFee/2933191115100"}]

receipt: 
"{\"id\":\"pi_3POLiBPDpDvq0kP91W1uBzOH\",\"object\":\"payment_intent\",\"amount\":2045,\"amount_capturable\":0,\"amount_received\":2045,\"canceled_at\":null,\"cancellation_reason\":null,\"capture_method\":\"automatic\",\"charges\":{\"object\":\"list\",\"data\":[{\"id\":\"ch_3POLiBPDpDvq0kP916w1ciKo\",\"object\":\"charge\",\"amount\":2045,\"application_fee\":\"fee_1POLiEPDpDvq0kP9NG8QhXpX\",\"balance_transaction\":{\"id\":\"txn_3POLiBPDpDvq0kP91oRypbcj\",\"object\":\"balance_transaction\",\"exchange_rate\":null},\"captured\":true,\"created\":1717601117,\"currency\":\"gbp\",\"failure_code\":null,\"failure_message\":null,\"fraud_details\":{},\"livemode\":true,\"metadata\":{\"email\":\"rozbrabner@gmail.com\",\"manual_entry\":\"false\",\"order_id\":\"ruPzsB7JgEualFWUxBoN2E0a2\",\"order_transaction_id\":\"7438989853020\",\"payments_charge_id\":\"2897193828700\",\"shop_id\":\"81985241436\",\"shop_name\":\"cowshed\",\"transaction_fee_tax_amount\":\"0\",\"transaction_fee_total_amount\":\"52\"},\"outcome\":{\"network_status\":\"approved_by_network\",\"reason\":null,\"risk_level\":\"normal\",\"seller_message\":\"Payment complete.\",\"type\":\"authorized\"},\"paid\":true,\"payment_intent\":\"pi_3POLiBPDpDvq0kP91W1uBzOH\",\"payment_method\":\"pm_1POLiBPDpDvq0kP9GmGe8gsP\",\"payment_method_details\":{\"card\":{\"amount_authorized\":2045,\"brand\":\"mastercard\",\"checks\":{\"address_line1_check\":\"pass\",\"address_postal_code_check\":\"pass\",\"cvc_check\":\"pass\"},\"country\":\"GB\",\"description\":\"Business Premium Debit\",\"ds_transaction_id\":null,\"exp_month\":2,\"exp_year\":2029,\"extended_authorization\":{\"status\":\"disabled\"},\"fingerprint\":\"TLbJO34sRCrgMZZY\",\"funding\":\"debit\",\"iin\":\"516760\",\"incremental_authorization\":{\"status\":\"unavailable\"},\"installments\":null,\"issuer\":\"REVOLUT LTD\",\"last4\":\"2858\",\"mandate\":null,\"moto\":null,\"multicapture\":{\"status\":\"unavailable\"},\"network\":\"mastercard\",\"network_token\":{\"used\":false},\"network_transaction_id\":\"BPDG17EG20605\",\"overcapture\":{\"maximum_amount_capturable\":2045,\"status\":\"unavailable\"},\"payment_account_reference\":\"5001EJR1J774ONBKNL5EKVPBRO3HK\",\"three_d_secure\":null,\"wallet\":null},\"type\":\"card\"},\"refunded\":false,\"source\":null,\"status\":\"succeeded\",\"mit_params\":{\"network_transaction_id\":\"BPDG17EG20605\"}}],\"has_more\":false,\"total_count\":1,\"url\":\"\\/v1\\/charges?payment_intent=pi_3POLiBPDpDvq0kP91W1uBzOH\"},\"confirmation_method\":\"manual\",\"created\":1717601115,\"currency\":\"gbp\",\"last_payment_error\":null,\"livemode\":true,\"metadata\":{\"email\":\"rozbrabner@gmail.com\",\"manual_entry\":\"false\",\"order_id\":\"ruPzsB7JgEualFWUxBoN2E0a2\",\"order_transaction_id\":\"7438989853020\",\"payments_charge_id\":\"2897193828700\",\"shop_id\":\"81985241436\",\"shop_name\":\"cowshed\",\"transaction_fee_tax_amount\":\"0\",\"transaction_fee_total_amount\":\"52\"},\"next_action\":null,\"payment_method\":\"pm_1POLiBPDpDvq0kP9GmGe8gsP\",\"payment_method_types\":[\"card\"],\"source\":null,\"status\":\"succeeded\"}"

amount_set:
{"shop_money":{"amount":20.45,"currency":"GBP"}}

payment_details: 
{"avs_result_code":"Y","cvv_result_code":"M","credit_card_bin":"516760","credit_card_company":"Mastercard","credit_card_number":"•••• •••• •••• 2858","credit_card_name":"Rosalind Brabner","credit_card_wallet":null,"credit_card_expiration_year":2029,"credit_card_expiration_month":2}

total_unsettled_set:
{"presentment_money":{"amount":0,"currency":"GBP"},"shop_money":{"amount":0,"currency":"GBP"}}