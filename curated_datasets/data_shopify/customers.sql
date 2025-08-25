-- Create materialized view for Shopify customers (FIXED)
CREATE MATERIALIZED VIEW data_shopify.customers
ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(assumeNotNull(updated_at))
ORDER BY (id, assumeNotNull(updated_at))
SETTINGS index_granularity = 8192
POPULATE
AS
SELECT 
    -- Core fields (non-PII)
    id,
    shop_url,
    created_at,
    updated_at,
    
    -- Marketing fields
    accepts_marketing,
    
    -- Email marketing consent (extracted from JSON)
    JSONExtractString(email_marketing_consent, 'state') as email_marketing_state,
    JSONExtractString(email_marketing_consent, 'opt_in_level') as email_opt_in_level,
    if(
        email_marketing_consent IS NULL 
        OR JSONExtractString(email_marketing_consent, 'consent_updated_at') IN ('', 'null'),
        NULL,
        parseDateTimeBestEffort(JSONExtractString(email_marketing_consent, 'consent_updated_at'))
    ) as email_consent_updated_at,
    
    -- SMS marketing consent (extracted from JSON)
    JSONExtractString(sms_marketing_consent, 'state') as sms_marketing_state,
    JSONExtractString(sms_marketing_consent, 'opt_in_level') as sms_opt_in_level,
    JSONExtractString(sms_marketing_consent, 'consent_collected_from') as sms_consent_collected_from,
    if(
        sms_marketing_consent IS NULL 
        OR JSONExtractString(sms_marketing_consent, 'consent_updated_at') IN ('', 'null'),
        NULL,
        parseDateTimeBestEffort(JSONExtractString(sms_marketing_consent, 'consent_updated_at'))
    ) as sms_consent_updated_at,
    
    -- Customer value metrics
    total_spent,
    orders_count,
    last_order_id,
    
    -- Other useful fields
    verified_email,
    tax_exempt,
    tax_exemptions,
    currency,
    tags,
    note,
    admin_graphql_api_id
    
FROM raw_shopify.customers
WHERE id IS NOT NULL 
  AND updated_at IS NOT NULL;