_airbyte_raw_id
STRING	REQUIRED	

_airbyte_extracted_at
TIMESTAMP	REQUIRED	

_airbyte_meta
JSON	REQUIRED

_airbyte_generation_id
INTEGER	NULLABLE

id
STRING	NULLABLE	

type
STRING	NULLABLE

links
JSON	NULLABLE	

updated
TIMESTAMP	NULLABLE

attributes
JSON	NULLABLE

relationships
JSON	NULLABLE

-- Example json strings: 

links: 
{"self":"https://a.klaviyo.com/api/flows/XBfth6/"}

attributes:
{"archived":false,"created":"2025-07-31T15:45:48+00:00","name":"Welcome Series New TEST","status":"draft","trigger_type":"Added to List","updated":"2025-07-31T15:46:22+00:00"}

relationships: 
{"flow-actions":{"links":{"related":"https://a.klaviyo.com/api/flows/XBfth6/flow-actions/","self":"https://a.klaviyo.com/api/flows/XBfth6/relationships/flow-actions/"}},"tags":{"links":{"related":"https://a.klaviyo.com/api/flows/XBfth6/tags/","self":"https://a.klaviyo.com/api/flows/XBfth6/relationships/tags/"}}}


