CREATE TABLE raw_shopify.fulfillments
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `name` Nullable(String),
    `duties` Nullable(String),
    `status` Nullable(String),
    `receipt` Nullable(String),
    `service` Nullable(String),
    `order_id` Nullable(Int64),
    `shop_url` Nullable(String),
    `created_at` Nullable(DateTime64(3)),
    `line_items` Nullable(String),
    `updated_at` Nullable(DateTime64(3)),
    `location_id` Nullable(Int64),
    `tracking_url` Nullable(String),
    `tracking_urls` Nullable(String),
    `origin_address` Nullable(String),
    `notify_customer` Nullable(Bool),
    `shipment_status` Nullable(String),
    `tracking_number` Nullable(String),
    `tracking_company` Nullable(String),
    `tracking_numbers` Nullable(String),
    `admin_graphql_api_id` Nullable(String),
    `variant_inventory_management` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192