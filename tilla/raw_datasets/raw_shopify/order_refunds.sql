CREATE TABLE raw_shopify.order_refunds
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `note` Nullable(String),
    `duties` Nullable(String),
    `return` Nullable(String),
    `restock` Nullable(Bool),
    `user_id` Nullable(Int64),
    `order_id` Nullable(Int64),
    `shop_url` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `processed_at` Nullable(String),
    `transactions` Nullable(String),
    `total_duties_set` Nullable(String),
    `order_adjustments` Nullable(String),
    `refund_line_items` Nullable(String),
    `admin_graphql_api_id` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192