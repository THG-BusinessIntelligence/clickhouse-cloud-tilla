-- Backfill for customer journey summary table (with proper NULL handling)
INSERT INTO data_shopify.customer_journey_summary
SELECT 
    -- Core fields
    order_id,
    shop_url,
    created_at,
    updated_at,
    admin_graphql_api_id,
    
    -- Extract journey summary data
    JSONExtractBool(customer_journey_summary, 'ready') as is_ready,
    JSONExtractInt(customer_journey_summary, 'moments_count', 'count') as moments_count,
    JSONExtractInt(customer_journey_summary, 'customer_order_index') as customer_order_index,
    JSONExtractInt(customer_journey_summary, 'days_to_conversion') as days_to_conversion,
    
    -- First visit info
    JSONExtractInt(customer_journey_summary, 'first_visit', 'id') as first_visit_id,
    JSONExtractString(customer_journey_summary, 'first_visit', 'landing_page') as first_visit_landing_page,
    CASE 
        WHEN JSONExtractString(customer_journey_summary, 'first_visit', 'occurred_at') = '' THEN NULL
        ELSE parseDateTimeBestEffort(JSONExtractString(customer_journey_summary, 'first_visit', 'occurred_at'))
    END as first_visit_occurred_at,
    JSONExtractString(customer_journey_summary, 'first_visit', 'referrer_url') as first_visit_referrer_url,
    JSONExtractString(customer_journey_summary, 'first_visit', 'source') as first_visit_source,
    JSONExtractString(customer_journey_summary, 'first_visit', 'source_type') as first_visit_source_type,
    JSONExtractString(customer_journey_summary, 'first_visit', 'source_description') as first_visit_source_description,
    JSONExtractString(customer_journey_summary, 'first_visit', 'utm_parameters') as first_visit_utm_parameters,
    
    -- Last visit info
    JSONExtractInt(customer_journey_summary, 'last_visit', 'id') as last_visit_id,
    JSONExtractString(customer_journey_summary, 'last_visit', 'landing_page') as last_visit_landing_page,
    CASE 
        WHEN JSONExtractString(customer_journey_summary, 'last_visit', 'occurred_at') = '' THEN NULL
        ELSE parseDateTimeBestEffort(JSONExtractString(customer_journey_summary, 'last_visit', 'occurred_at'))
    END as last_visit_occurred_at,
    JSONExtractString(customer_journey_summary, 'last_visit', 'referrer_url') as last_visit_referrer_url,
    JSONExtractString(customer_journey_summary, 'last_visit', 'source') as last_visit_source,
    JSONExtractString(customer_journey_summary, 'last_visit', 'source_type') as last_visit_source_type,
    JSONExtractString(customer_journey_summary, 'last_visit', 'source_description') as last_visit_source_description,
    JSONExtractString(customer_journey_summary, 'last_visit', 'utm_parameters') as last_visit_utm_parameters
    
FROM raw_shopify.customer_journey_summary
WHERE order_id IS NOT NULL 
  AND updated_at IS NOT NULL;