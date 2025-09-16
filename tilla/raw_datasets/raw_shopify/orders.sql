CREATE TABLE raw_shopify.orders
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `name` Nullable(String),
    `note_hashed` Nullable(String),
    `tags` Nullable(String),
    `test` Nullable(Bool),
    `email_hashed` Nullable(String),
    `phone_hashed` Nullable(String),
    `token` Nullable(String),
    `app_id` Nullable(Int64),
    `number` Nullable(Int64),
    `company` Nullable(String),
    `refunds` Nullable(String),
    `user_id` Nullable(Decimal(38, 9)),
    `currency` Nullable(String),
    `customer_hashed` Nullable(String),
    `shop_url` Nullable(String),
    `closed_at` Nullable(DateTime64(3)),
    `confirmed` Nullable(Bool),
    `device_id` Nullable(String),
    `po_number` Nullable(String),
    `reference` Nullable(String),
    `tax_lines` Nullable(String),
    `total_tax` Nullable(Decimal(38, 9)),
    `browser_ip_hashed` Nullable(String),
    `cart_token` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `deleted_at` Nullable(DateTime64(3)),
    `line_items` Nullable(String),
    `source_url` Nullable(String),
    `tax_exempt` Nullable(Bool),
    `updated_at` Nullable(DateTime64(3)),
    `checkout_id` Nullable(Int64),
    `location_id` Nullable(Int64),
    `source_name` Nullable(String),
    `total_price` Nullable(Decimal(38, 9)),
    `cancelled_at` Nullable(DateTime64(3)),
    `fulfillments` Nullable(String),
    `landing_site` Nullable(String),
    `order_number` Nullable(Int64),
    `processed_at` Nullable(String),
    `total_weight` Nullable(Int64),
    `cancel_reason` Nullable(String),
    `contact_email_hashed` Nullable(String),
    `payment_terms` Nullable(String),
    `total_tax_set` Nullable(String),
    `checkout_token` Nullable(String),
    `client_details_hashed` Nullable(String),
    `discount_codes` Nullable(String),
    `referring_site` Nullable(String),
    `shipping_lines_hashed` Nullable(String),
    `subtotal_price` Nullable(Decimal(38, 9)),
    `taxes_included` Nullable(Bool),
    `billing_address_hashed` Nullable(String),
    `customer_locale` Nullable(String),
    `deleted_message` Nullable(String),
    `duties_included` Nullable(Bool),
    `estimated_taxes` Nullable(Bool),
    `note_attributes` Nullable(String),
    `total_discounts` Nullable(Decimal(38, 9)),
    `total_price_set` Nullable(String),
    `total_price_usd` Nullable(Decimal(38, 9)),
    `financial_status` Nullable(String),
    `landing_site_ref` Nullable(String),
    `order_status_url` Nullable(String),
    `shipping_address_hashed` Nullable(String),
    `current_total_tax` Nullable(Decimal(38, 9)),
    `source_identifier` Nullable(String),
    `total_outstanding` Nullable(Decimal(38, 9)),
    `fulfillment_status` Nullable(String),
    `subtotal_price_set` Nullable(String),
    `total_tip_received` Nullable(Decimal(38, 9)),
    `confirmation_number` Nullable(String),
    `current_total_price` Nullable(Decimal(38, 9)),
    `deleted_description` Nullable(String),
    `total_discounts_set` Nullable(String),
    `admin_graphql_api_id` Nullable(String),
    `discount_allocations` Nullable(String),
    `presentment_currency` Nullable(String),
    `current_total_tax_set` Nullable(String),
    `discount_applications` Nullable(String),
    `payment_gateway_names` Nullable(String),
    `current_subtotal_price` Nullable(Decimal(38, 9)),
    `total_line_items_price` Nullable(Decimal(38, 9)),
    `buyer_accepts_marketing` Nullable(Bool),
    `current_total_discounts` Nullable(Decimal(38, 9)),
    `current_total_price_set` Nullable(String),
    `current_total_duties_set` Nullable(String),
    `total_shipping_price_set` Nullable(String),
    `merchant_of_record_app_id` Nullable(String),
    `original_total_duties_set` Nullable(String),
    `current_subtotal_price_set` Nullable(String),
    `total_line_items_price_set` Nullable(String),
    `current_total_discounts_set` Nullable(String),
    `merchant_business_entity_id` Nullable(String),
    `current_total_additional_fees_set` Nullable(String),
    `original_total_additional_fees_set` Nullable(String),
    `total_cash_rounding_payment_adjustment_set` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192


----- Nested JSON Field Example Data ------ 

refunds:
[{"id":1001108635996,"admin_graphql_api_id":"gid://shopify/Refund/1001108635996","created_at":"2024-06-05T20:46:10+01:00","note":"Order canceled","order_id":6127281406300,"processed_at":"2024-06-05T20:46:10+01:00","restock":true,"total_duties_set":{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}},"user_id":103972503900,"order_adjustments":[{"id":335599927644,"amount":"-3.95","amount_set":{"shop_money":{"amount":"-3.95","currency_code":"GBP"},"presentment_money":{"amount":"-3.95","currency_code":"GBP"}},"kind":"shipping_refund","order_id":6127281406300,"reason":"Shipping refund","refund_id":1001108635996,"tax_amount":"0.00","tax_amount_set":{"shop_money":{"amount":"0.00","currency_code":"GBP"},"presentment_money":{"amount":"0.00","currency_code":"GBP"}}},{"id":357346345308,"amount":"3.95","amount_set":{"shop_money":{"amount":"3.95","currency_code":"GBP"},"presentment_money":{"amount":"3.95","currency_code":"GBP"}},"kind":"shipping_refund","order_id":6127281406300,"reason":"Shipping refund","refund_id":1001108635996,"tax_amount":"0.00","tax_amount_set":{"shop_money":{"amount":"0.00","currency_code":"GBP"},"presentment_money":{"amount":"0.00","currency_code":"GBP"}}},{"id":357346378076,"amount":"-3.95","amount_set":{"shop_money":{"amount":"-3.95","currency_code":"GBP"},"presentment_money":{"amount":"-3.95","currency_code":"GBP"}},"kind":"shipping_refund","order_id":6127281406300,"reason":"Shipping refund","refund_id":1001108635996,"tax_amount":"0.00","tax_amount_set":{"shop_money":{"amount":"0.00","currency_code":"GBP"},"presentment_money":{"amount":"0.00","currency_code":"GBP"}}}],"transactions":[{"id":7439685189980,"admin_graphql_api_id":"gid://shopify/OrderTransaction/7439685189980","amount":"20.45","authorization":"re_3POLiBPDpDvq0kP91uESA7TZ","created_at":"2024-06-05T20:46:07+01:00","currency":"GBP","device_id":null,"error_code":null,"gateway":"shopify_payments","kind":"refund","location_id":null,"message":"Transaction approved","order_id":6127281406300,"parent_id":7438989853020,"payment_id":"#1001.2","payments_refund_attributes":{"status":"success","acquirer_reference_number":"85383904158000024861388"},"processed_at":"2024-06-05T20:46:10+01:00","receipt":{"id":"re_3POLiBPDpDvq0kP91uESA7TZ","amount":2045,"balance_transaction":{"id":"txn_3POLiBPDpDvq0kP91pMrIlUQ","object":"balance_transaction","exchange_rate":null},"charge":{"id":"ch_3POLiBPDpDvq0kP916w1ciKo","object":"charge","amount":2045,"application_fee":"fee_1POLiEPDpDvq0kP9NG8QhXpX","balance_transaction":"txn_3POLiBPDpDvq0kP91oRypbcj","captured":true,"created":1717601117,"currency":"gbp","failure_code":null,"failure_message":null,"fraud_details":{},"livemode":true,"metadata":{"email":"rozbrabner@gmail.com","manual_entry":"false","order_id":"ruPzsB7JgEualFWUxBoN2E0a2","order_transaction_id":"7438989853020","payments_charge_id":"2897193828700","shop_id":"81985241436","shop_name":"cowshed","transaction_fee_tax_amount":"0","transaction_fee_total_amount":"52"},"outcome":{"network_status":"approved_by_network","reason":null,"risk_level":"normal","seller_message":"Payment complete.","type":"authorized"},"paid":true,"payment_intent":"pi_3POLiBPDpDvq0kP91W1uBzOH","payment_method":"pm_1POLiBPDpDvq0kP9GmGe8gsP","payment_method_details":{"card":{"amount_authorized":2045,"brand":"mastercard","checks":{"address_line1_check":"pass","address_postal_code_check":"pass","cvc_check":"pass"},"country":"GB","description":"Business Premium Debit","ds_transaction_id":null,"exp_month":2,"exp_year":2029,"extended_authorization":{"status":"disabled"},"fingerprint":"TLbJO34sRCrgMZZY","funding":"debit","iin":"516760","incremental_authorization":{"status":"unavailable"},"installments":null,"issuer":"REVOLUT LTD","last4":"2858","mandate":null,"moto":null,"multicapture":{"status":"unavailable"},"network":"mastercard","network_token":{"used":false},"network_transaction_id":"BPDG17EG20605","overcapture":{"maximum_amount_capturable":2045,"status":"unavailable"},"payment_account_reference":"5001EJR1J774ONBKNL5EKVPBRO3HK","three_d_secure":null,"wallet":null},"type":"card"},"refunded":true,"source":null,"status":"succeeded","mit_params":{"network_transaction_id":"BPDG17EG20605"}},"object":"refund","reason":null,"status":"succeeded","created":1717616768,"currency":"gbp","metadata":{"order_transaction_id":"7439685189980","payments_refund_id":"138495295836"},"payment_method_details":{"card":{"acquirer_reference_number":null,"acquirer_reference_number_status":"pending"},"type":"card"},"mit_params":{}},"source_name":"1830279","status":"success","test":false,"user_id":103972503900,"payment_details":{"credit_card_bin":"516760","avs_result_code":"Y","cvv_result_code":"M","credit_card_number":"•••• •••• •••• 2858","credit_card_company":"Mastercard","buyer_action_info":null,"credit_card_name":"Rosalind Brabner","credit_card_wallet":null,"credit_card_expiration_month":2,"credit_card_expiration_year":2029,"payment_method_name":"master"}}],"refund_line_items":[{"id":658470142300,"line_item_id":15679468470620,"location_id":91390607708,"quantity":1,"restock_type":"cancel","subtotal":16.5,"subtotal_set":{"shop_money":{"amount":"16.50","currency_code":"GBP"},"presentment_money":{"amount":"16.50","currency_code":"GBP"}},"total_tax":0,"total_tax_set":{"shop_money":{"amount":"0.00","currency_code":"GBP"},"presentment_money":{"amount":"0.00","currency_code":"GBP"}},"line_item":{"id":15679468470620,"admin_graphql_api_id":"gid://shopify/LineItem/15679468470620","attributed_staffs":[],"current_quantity":0,"fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":383,"name":"Active Bath & Shower Gel - 300ml","pre_tax_price":"16.50","pre_tax_price_set":{"shop_money":{"amount":"16.50","currency_code":"GBP"},"presentment_money":{"amount":"16.50","currency_code":"GBP"}},"price":"22.00","price_set":{"shop_money":{"amount":"22.00","currency_code":"GBP"},"presentment_money":{"amount":"22.00","currency_code":"GBP"}},"product_exists":true,"product_id":9341498130780,"properties":[],"quantity":1,"requires_shipping":true,"sku":"100509","taxable":false,"title":"Active Bath & Shower Gel","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"GBP"},"presentment_money":{"amount":"0.00","currency_code":"GBP"}},"variant_id":48672357450076,"variant_inventory_management":"shopify","variant_title":"300ml","vendor":"cowshed","tax_lines":[{"channel_liable":false,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"GBP"},"presentment_money":{"amount":"0.00","currency_code":"GBP"}},"rate":0.2,"title":"GB VAT"}],"duties":[],"discount_allocations":[{"amount":"5.50","amount_set":{"shop_money":{"amount":"5.50","currency_code":"GBP"},"presentment_money":{"amount":"5.50","currency_code":"GBP"}},"discount_application_index":0}]}}],"duties":[]}]

line_items:
[{"id":15679468470620,"admin_graphql_api_id":"gid://shopify/LineItem/15679468470620","attributed_staffs":[],"current_quantity":0,"fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":383,"name":"Active Bath & Shower Gel - 300ml","pre_tax_price":16.5,"pre_tax_price_set":{"shop_money":{"amount":"16.50","currency_code":"GBP"},"presentment_money":{"amount":"16.50","currency_code":"GBP"}},"price":22,"price_set":{"shop_money":{"amount":22,"currency_code":"GBP"},"presentment_money":{"amount":22,"currency_code":"GBP"}},"product_exists":true,"product_id":9341498130780,"properties":[],"quantity":1,"requires_shipping":true,"sku":"100509","taxable":false,"title":"Active Bath & Shower Gel","total_discount":0,"total_discount_set":{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}},"variant_id":48672357450076,"variant_inventory_management":"shopify","variant_title":"300ml","vendor":"cowshed","tax_lines":[{"channel_liable":false,"price":0,"price_set":{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}},"rate":0.2,"title":"GB VAT"}],"duties":[],"discount_allocations":[{"amount":"5.50","amount_set":{"shop_money":{"amount":"5.50","currency_code":"GBP"},"presentment_money":{"amount":"5.50","currency_code":"GBP"}},"discount_application_index":0}]}]

fulfilment_items:
[{"id":5528139530588,"admin_graphql_api_id":"gid://shopify/Fulfillment/5528139530588","created_at":"2024-06-07T16:59:14+01:00","location_id":91390607708,"name":"#1002.1","order_id":6127428141404,"origin_address":{},"receipt":{},"service":"manual","shipment_status":null,"status":"success","tracking_company":"Hermes","tracking_number":"H008WA0009067598","tracking_numbers":["H008WA0009067598"],"tracking_url":"https://www.evri.com/track/#/parcel/H008WA0009067598","tracking_urls":["https://www.evri.com/track/#/parcel/H008WA0009067598"],"updated_at":"2024-06-07T16:59:15+01:00","line_items":[{"id":15679856738652,"admin_graphql_api_id":"gid://shopify/LineItem/15679856738652","attributed_staffs":[],"current_quantity":1,"fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":"fulfilled","gift_card":false,"grams":220,"name":"Indulge Room Candle - 220g","pre_tax_price":38,"pre_tax_price_set":{"shop_money":{"amount":"38.00","currency_code":"GBP"},"presentment_money":{"amount":"38.00","currency_code":"GBP"}},"price":38,"price_set":{"shop_money":{"amount":38,"currency_code":"GBP"},"presentment_money":{"amount":38,"currency_code":"GBP"}},"product_exists":true,"product_id":9341500522844,"properties":[],"quantity":1,"requires_shipping":true,"sku":"100685","taxable":false,"title":"Indulge Room Candle","total_discount":0,"total_discount_set":{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}},"variant_id":48672363315548,"variant_inventory_management":"shopify","variant_title":"220g","vendor":"cowshed","tax_lines":[{"channel_liable":false,"price":0,"price_set":{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}},"rate":0.2,"title":"GB VAT"}],"duties":[],"discount_allocations":[]}]}]

total_tax_set:
{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}}

total_price_set:
{"shop_money":{"amount":41.95,"currency_code":"GBP"},"presentment_money":{"amount":41.95,"currency_code":"GBP"}}

sub_total_price_set: 
{"shop_money":{"amount":38,"currency_code":"GBP"},"presentment_money":{"amount":38,"currency_code":"GBP"}}

total_discount_set:
{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}}

current_total_tax_set:
{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}}

discount_applications:
[{"target_type":"line_item","type":"automatic","value":"25.0","value_type":"percentage","allocation_method":"across","target_selection":"entitled","title":"House Member"}]

payment_gateway: 
["shopify_payments"]

current_total_price:
{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}}

total_shipping_price_set:
{"shop_money":{"amount":3.95,"currency_code":"GBP"},"presentment_money":{"amount":3.95,"currency_code":"GBP"}}

current_subtotal_price_set: 
{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}}

total_line_item_price_set:
{"shop_money":{"amount":22,"currency_code":"GBP"},"presentment_money":{"amount":22,"currency_code":"GBP"}}

current_total_discounts_set:
{"shop_money":{"amount":0,"currency_code":"GBP"},"presentment_money":{"amount":0,"currency_code":"GBP"}}

total_cash_rounding_payment_adjustment_set: 
{"shop_money":{"amount":"0.00","currency_code":"GBP"},"presentment_money":{"amount":"0.00","currency_code":"GBP"}}