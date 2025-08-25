CREATE TABLE raw_shopify.inventory_items
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `sku` Nullable(String),
    `cost` Nullable(Decimal(38, 9)),
    `tracked` Nullable(Bool),
    `shop_url` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `updated_at` Nullable(DateTime64(3)),
    `currency_code` Nullable(String),
    `requires_shipping` Nullable(Bool),
    `duplicate_sku_count` Nullable(Int64),
    `admin_graphql_api_id` Nullable(String),
    `country_code_of_origin` Nullable(String),
    `harmonized_system_code` Nullable(String),
    `province_code_of_origin` Nullable(String),
    `country_harmonized_system_codes` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192