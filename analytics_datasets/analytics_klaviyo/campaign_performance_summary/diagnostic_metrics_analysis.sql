-- Let's understand how metrics are actually stored in the events table
-- We need to see what event types exist and how to count them

-- First, let's see all event types in the last 30 days
WITH event_summary AS (
  SELECT 
    type as event_type,
    COUNT(*) as event_count,
    -- Check if these events have campaign information
    COUNT(JSON_VALUE(attributes, '$.event_properties."Campaign Name"')) as events_with_campaign,
    -- Sample the structure
    ANY_VALUE(JSON_VALUE(attributes, '$.event_properties."Campaign Name"')) as sample_campaign_name,
    ANY_VALUE(JSON_VALUE(attributes, '$.event_properties."$message"')) as sample_message_id
  FROM 
    `grind-on-paytok.raw_klaviyo.events`
  WHERE 
    datetime >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY 
    type
  ORDER BY 
    event_count DESC
)
SELECT * FROM event_summary;

-- Now let's look at specific campaign events and understand their structure
WITH campaign_events AS (
  SELECT 
    type,
    JSON_VALUE(attributes, '$.event_properties."Campaign Name"') as campaign_name,
    JSON_VALUE(attributes, '$.event_properties."$message"') as message_id,
    JSON_VALUE(attributes, '$.event_properties."$event_id"') as event_id,
    -- Check for different value fields
    JSON_VALUE(attributes, '$.event_properties."$value"') as event_value,
    JSON_VALUE(attributes, '$.event_properties."Ordered Product Count"') as ordered_products,
    JSON_VALUE(attributes, '$.event_properties."Total Order Value"') as order_value,
    -- Count events
    1 as event_record
  FROM 
    `grind-on-paytok.raw_klaviyo.events`
  WHERE 
    datetime >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(attributes, '$.event_properties."Campaign Name"') IS NOT NULL
  LIMIT 1000
)
SELECT 
  type,
  COUNT(*) as total_events,
  COUNT(DISTINCT campaign_name) as unique_campaigns,
  -- Show sample values
  ANY_VALUE(campaign_name) as sample_campaign,
  ANY_VALUE(message_id) as sample_message,
  ANY_VALUE(event_value) as sample_value,
  ANY_VALUE(ordered_products) as sample_products,
  ANY_VALUE(order_value) as sample_order_value
FROM campaign_events
GROUP BY type
ORDER BY total_events DESC;

-- Finally, let's see how to properly aggregate metrics for a specific campaign
WITH campaign_metrics AS (
  SELECT 
    DATE(datetime) as event_date,
    JSON_VALUE(attributes, '$.event_properties."Campaign Name"') as campaign_name,
    type as event_type,
    -- Count the events
    COUNT(*) as event_count,
    -- Try to sum any values
    SUM(CAST(JSON_VALUE(attributes, '$.event_properties."$value"') AS FLOAT64)) as total_value,
    SUM(CAST(JSON_VALUE(attributes, '$.event_properties."Ordered Product Count"') AS INT64)) as total_products
  FROM 
    `grind-on-paytok.raw_klaviyo.events`
  WHERE 
    datetime >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND JSON_VALUE(attributes, '$.event_properties."Campaign Name"') = '1.7.2025 - Peanuts Launch - OTP Customers - 90 days - Purchased in the last 180 days - NL'
  GROUP BY 
    event_date, campaign_name, event_type
)
SELECT * FROM campaign_metrics
ORDER BY event_date DESC, event_type;