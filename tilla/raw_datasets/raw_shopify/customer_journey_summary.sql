CREATE TABLE raw_shopify.customer_journey_summary
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `order_id` Int64,
    `shop_url` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `updated_at` Nullable(DateTime64(3)),
    `admin_graphql_api_id` Nullable(String),
    `customer_journey_summary` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY order_id
SETTINGS index_granularity = 8192