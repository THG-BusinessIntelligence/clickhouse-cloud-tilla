	
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

attributes
JSON        NULLABLE

updated_at
TIMESTAMP	NULLABLE

relationships
JSON

-- Example json strings

LINKS: 
{"self":"https://a.klaviyo.com/api/campaigns/01K2YD0FH7E3VN1DDPS27K0XKT/"}

ATTRIBUTES:
{"archived":false,"audiences":{"excluded":["QVnHqb","RyCk2b"],"included":["YwFiXz"]},"channel":"email","created_at":"2025-08-18T10:53:40.778176+00:00","name":"5.9.2025 - Advent Calendar Push - NL","scheduled_at":null,"send_options":{"ignore_unsubscribes":false,"use_smart_sending":false},"send_strategy":{"method":"static","options_static":{"datetime":"2025-08-17T23:00:00+00:00","is_local":false,"send_past_recipients_immediately":null},"options_sto":null,"options_throttled":null},"send_time":null,"status":"Draft","tracking_options":{"add_tracking_params":true,"custom_tracking_params":[],"is_tracking_clicks":true,"is_tracking_opens":true},"updated_at":"2025-08-18T10:54:47.993096+00:00"}

RELATIONSHIPS:
{"campaign-messages":{"data":[{"id":"01K2YD0FHED3B8NF0RDJR4M4X4","type":"campaign-message"}],"links":{"related":"https://a.klaviyo.com/api/campaigns/01K2YD0FH7E3VN1DDPS27K0XKT/campaign-messages/","self":"https://a.klaviyo.com/api/campaigns/01K2YD0FH7E3VN1DDPS27K0XKT/relationships/campaign-messages/"}},"tags":{"links":{"related":"https://a.klaviyo.com/api/campaigns/01K2YD0FH7E3VN1DDPS27K0XKT/tags/","self":"https://a.klaviyo.com/api/campaigns/01K2YD0FH7E3VN1DDPS27K0XKT/relationships/tags/"}}}

