CREATE TABLE raw_shopify.inventory_levels
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` String,
    `shop_url` Nullable(String),
    `available` Nullable(Int64),
    `created_at` Nullable(DateTime64(3)),
    `quantities` Nullable(String),
    `updated_at` Nullable(DateTime64(3)),
    `location_id` Nullable(Int64),
    `can_deactivate` Nullable(Bool),
    `locations_count` Nullable(String),
    `inventory_item_id` Nullable(Int64),
    `deactivation_alert` Nullable(String),
    `admin_graphql_api_id` Nullable(String),
    `inventory_history_url` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192