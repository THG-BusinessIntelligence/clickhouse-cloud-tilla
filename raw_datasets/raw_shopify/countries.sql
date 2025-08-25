CREATE TABLE raw_shopify.countries
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `code` Nullable(String),
    `name` Nullable(String),
    `shop_url` Nullable(String),
    `provinces` Nullable(String),
    `rest_of_world` Nullable(Bool),
    `translated_name` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192