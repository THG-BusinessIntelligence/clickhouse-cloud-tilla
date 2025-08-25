--- AMMENDED WITH FIX 
CREATE MATERIALIZED VIEW data_shopify.customer_journey_detail
ENGINE = MergeTree()
ORDER BY (order_id, visit_id, occurred_at)
SETTINGS index_granularity = 8192
AS
WITH moments_array AS (
    SELECT 
        order_id,
        updated_at,
        JSONExtract(assumeNotNull(customer_journey_summary), 'moments', 'Array(String)') as moments
    FROM raw_shopify.customer_journey_summary
    WHERE order_id IS NOT NULL 
      AND customer_journey_summary IS NOT NULL
      AND JSONExtractInt(customer_journey_summary, 'moments_count', 'count') > 0
)
SELECT 
    order_id,
    updated_at as journey_updated_at,
    JSONExtractInt(arrayElement(moments, n), 'id') as visit_id,
    n as visit_sequence,
    JSONExtractString(arrayElement(moments, n), 'landing_page') as landing_page,
    ifNull(parseDateTimeBestEffort(JSONExtractString(arrayElement(moments, n), 'occurred_at')), NULL) as occurred_at,
    JSONExtractString(arrayElement(moments, n), 'referrer_url') as referrer_url,
    JSONExtractString(arrayElement(moments, n), 'source') as source,
    JSONExtractString(arrayElement(moments, n), 'source_type') as source_type,
    JSONExtractString(arrayElement(moments, n), 'source_description') as source_description,
    JSONExtractString(arrayElement(moments, n), 'utm_parameters') as utm_parameters,
    JSONExtractString(arrayElement(moments, n), 'admin_graphql_api_id') as admin_graphql_api_id
FROM moments_array
ARRAY JOIN range(1, length(moments) + 1) as n;
