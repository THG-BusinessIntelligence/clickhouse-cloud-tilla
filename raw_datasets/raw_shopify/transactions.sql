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