CREATE TABLE raw_shopify.customers
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `note` Nullable(String),
    `tags` Nullable(String),
    `email_hashed` Nullable(String),
    `phone_hashed` Nullable(String),
    `state_hashed` Nullable(String),
    `currency` Nullable(String),
    `shop_url` Nullable(String),
    `addresses_hashed` Nullable(String),
    `last_name_hashed` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `first_name_hashed` Nullable(String),
    `tax_exempt` Nullable(Bool),
    `updated_at` Nullable(DateTime64(3)),
    `total_spent` Nullable(Decimal(38, 9)),
    `orders_count` Nullable(Int64),
    `last_order_id` Nullable(Int64),
    `tax_exemptions` Nullable(String),
    `verified_email` Nullable(Bool),
    `default_address_hashed` Nullable(String),
    `last_order_name` Nullable(String),
    `accepts_marketing` Nullable(Bool),
    `admin_graphql_api_id` Nullable(String),
    `multipass_identifier` Nullable(String),
    `sms_marketing_consent` Nullable(String),
    `marketing_opt_in_level` Nullable(String),
    `email_marketing_consent` Nullable(String),
    `accepts_marketing_updated_at` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192