-- View for Shopify locations
CREATE VIEW data_shopify.locations
AS SELECT
    id,
    zip,
    city,
    name,
    phone,
    active,
    legacy,
    country,
    address1,
    address2,
    province,
    shop_url,
    created_at,
    updated_at,
    country_code,
    country_name,
    province_code,
    admin_graphql_api_id,
    localized_country_name,
    localized_province_name
FROM raw_shopify.locations;