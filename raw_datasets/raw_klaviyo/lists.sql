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

-- example json strings: 
links:
{"self":"https://a.klaviyo.com/api/lists/H4vTsL/"}

attributes:
{"created":"2019-12-02T10:02:09+00:00","name":"Filled in Batch 3 survey v2","opt_in_process":"double_opt_in","updated":"2019-12-02T10:06:04+00:00"}

relationships:
{"flow-triggers":{"links":{"related":"https://a.klaviyo.com/api/lists/H4vTsL/flow-triggers/","self":"https://a.klaviyo.com/api/lists/H4vTsL/relationships/flow-triggers/"}},"profiles":{"links":{"related":"https://a.klaviyo.com/api/lists/H4vTsL/profiles/","self":"https://a.klaviyo.com/api/lists/H4vTsL/relationships/profiles/"}},"tags":{"links":{"related":"https://a.klaviyo.com/api/lists/H4vTsL/tags/","self":"https://a.klaviyo.com/api/lists/H4vTsL/relationships/tags/"}}}