CREATE TABLE raw_shopify.locations
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `zip` Nullable(String),
    `city` Nullable(String),
    `name` Nullable(String),
    `phone` Nullable(String),
    `active` Nullable(Bool),
    `legacy` Nullable(Bool),
    `country` Nullable(String),
    `address1` Nullable(String),
    `address2` Nullable(String),
    `province` Nullable(String),
    `shop_url` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `updated_at` Nullable(DateTime64(3)),
    `country_code` Nullable(String),
    `country_name` Nullable(String),
    `province_code` Nullable(String),
    `admin_graphql_api_id` Nullable(String),
    `localized_country_name` Nullable(String),
    `localized_province_name` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192