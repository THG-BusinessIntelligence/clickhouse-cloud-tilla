CREATE TABLE raw_shopify.customer_address
(
    `_airbyte_raw_id` String,
    `_airbyte_extracted_at` DateTime64(3),
    `_airbyte_meta` String,
    `_airbyte_generation_id` UInt32,
    `id` Int64,
    `zip_hashed` Nullable(String),
    `city_hashed` Nullable(String),
    `name_hashed` Nullable(String),
    `phone_hashed` Nullable(String),
    `company_hashed` Nullable(String),
    `country` Nullable(String),
    `default` Nullable(Bool),
    `address1_hashed` Nullable(String),
    `address2_hashed` Nullable(String),
    `province` Nullable(String),
    `shop_url` Nullable(String),
    `last_name_hashed` Nullable(String),
    `first_name_hashed` Nullable(String),
    `updated_at` Nullable(DateTime64(3)),
    `customer_id` Nullable(Int64),
    `country_code` Nullable(String),
    `country_name` Nullable(String),
    `province_code` Nullable(String)
)
ENGINE = SharedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id
SETTINGS index_granularity = 8192