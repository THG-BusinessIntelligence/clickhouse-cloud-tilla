-- Create materialized view for Shopify shop
-- Shop contains store-level configuration and settings
CREATE MATERIALIZED VIEW data_shopify.shop
ENGINE = ReplacingMergeTree()
ORDER BY (id, assumeNotNull(updated_at))
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    -- Core shop identification
    id AS shop_id,
    name AS shop_name,
    domain,
    myshopify_domain,
    shop_url,
    
    -- Shop settings
    currency,
    money_format,
    money_with_currency_format,
    weight_unit,
    timezone,
    iana_timezone,
    primary_locale,
    
    -- Location info (non-PII)
    country,
    country_code,
    country_name,
    
    -- Plan information
    plan_name,
    plan_display_name,
    
    -- Features and capabilities
    has_storefront,
    has_discounts,
    has_gift_cards,
    finances,
    eligible_for_payments,
    eligible_for_card_reader_giveaway,
    checkout_api_supported,
    multi_location_enabled,
    
    -- Tax settings
    taxes_included,
    tax_shipping,
    county_taxes,
    auto_configure_tax_inclusivity,
    
    -- Other settings
    password_enabled,
    pre_launch_enabled,
    force_ssl,
    setup_required,
    
    -- Compliance and tracking
    cookie_consent_level,
    visitor_tracking_consent_preference,
    
    -- Marketing settings
    transactional_sms_disabled,
    marketing_sms_consent_enabled_at_checkout,
    
    -- Primary location
    primary_location_id,
    
    -- Currencies
    if(isNull(enabled_presentment_currencies), [], 
       JSONExtractArrayRaw(assumeNotNull(enabled_presentment_currencies))) AS enabled_currencies,
    
    -- Timestamps
    created_at,
    updated_at
    
FROM raw_shopify.shop
WHERE id IS NOT NULL;