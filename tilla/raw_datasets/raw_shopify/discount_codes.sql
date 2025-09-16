CREATE TABLE raw_shopify.discount_codes
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `code` Nullable(String),
    `title` Nullable(String),
    `status` Nullable(String),
    `ends_at` Nullable(DateTime64(3)),
    `summary` Nullable(String),
    `shop_url` Nullable(String),
    `typename` Nullable(String),
    `createdBy` Nullable(String),
    `starts_at` Nullable(DateTime64(3)),
    `created_at` Nullable(DateTime64(3)),
    `updated_at` Nullable(DateTime64(3)),
    `codes_count` Nullable(String),
    `total_sales` Nullable(String),
    `usage_count` Nullable(Int64),
    `usage_limit` Nullable(Int64),
    `discount_type` Nullable(String),
    `price_rule_id` Nullable(Int64),
    `async_usage_count` Nullable(Int64),
    `admin_graphql_api_id` Nullable(String),
    `applies_once_per_customer` Nullable(Bool)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192