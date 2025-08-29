-- Test query to verify correct JSONPath syntax for keys with $ prefix in BigQuery
-- Run this query to test which syntax works

WITH test_data AS (
  SELECT 
    e.attributes,
    -- Test different extraction methods
    JSON_EXTRACT_SCALAR(e.attributes, '$.event_properties.\\$ESP') AS test1_backslash,
    JSON_EXTRACT_SCALAR(e.attributes, '$.event_properties["$ESP"]') AS test2_double_quotes,
    JSON_EXTRACT_SCALAR(e.attributes, "$.event_properties['$ESP']") AS test3_single_quotes,
    JSON_VALUE(e.attributes, '$.event_properties."$ESP"') AS test4_json_value,
    JSON_EXTRACT_SCALAR(e.attributes, '$.event_properties.$ESP') AS test5_direct,
    
    -- Also test Campaign Name extraction
    JSON_EXTRACT_SCALAR(e.attributes, '$.event_properties."Campaign Name"') AS campaign_name_test1,
    JSON_EXTRACT_SCALAR(e.attributes, '$.event_properties.Campaign Name') AS campaign_name_test2
    
  FROM `tilla-2-grind.klaviyo.events` e
  WHERE DATE(e.datetime) = CURRENT_DATE() - 1  -- Yesterday's data
  LIMIT 10
)
SELECT * FROM test_data
WHERE test1_backslash IS NOT NULL 
   OR test2_double_quotes IS NOT NULL 
   OR test3_single_quotes IS NOT NULL
   OR test4_json_value IS NOT NULL
   OR test5_direct IS NOT NULL
   OR campaign_name_test1 IS NOT NULL
   OR campaign_name_test2 IS NOT NULL;

-- Alternative: Test with a known JSON structure
WITH sample_json AS (
  SELECT 
    '{"event_properties": {"$ESP": 1, "$message": "test123", "Campaign Name": "Test Campaign"}}' AS json_str
)
SELECT
  JSON_EXTRACT_SCALAR(json_str, '$.event_properties."$ESP"') AS double_quote_test,
  JSON_EXTRACT_SCALAR(json_str, '$.event_properties["$ESP"]') AS bracket_test,
  JSON_EXTRACT_SCALAR(json_str, '$.event_properties.$ESP') AS direct_test,
  JSON_VALUE(json_str, '$.event_properties."$ESP"') AS json_value_test
FROM sample_json;