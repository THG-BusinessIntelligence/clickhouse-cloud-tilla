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

datetime
TIMESTAMP	NULLABLE

attributes
JSON	NULLABLE

relationships
JSON	NULLABLE


-- Example json strings 

links:
{"self":"https://a.klaviyo.com/api/events/32CLkDXR68M/"}

attributes:
{"datetime":"2022-01-23T09:05:16+00:00","event_properties":{"$ESP":0,"$_cohort$message_send_cohort":"1642928713:UupFUS","$event_id":"UupFUS:128291358961623399757976539970236599108","$message":"UupFUS","Campaign Name":"v2 Jan 2022 UGC Email 1 - Sustainability Focus","Email Domain":"yahoo.fr","Subject":"C'ya plastic coffee pods."},"timestamp":1642928716,"uuid":"9496ee00-7c2b-11ec-8001-a58968c2bc84"}

relationships:
{"metric":{"data":{"id":"Qfbz2d","type":"metric"},"links":{"related":"https://a.klaviyo.com/api/events/32CLkDXR68M/metric/","self":"https://a.klaviyo.com/api/events/32CLkDXR68M/relationships/metric/"}},"profile":{"data":{"id":"QqXc3w","type":"profile"},"links":{"related":"https://a.klaviyo.com/api/events/32CLkDXR68M/profile/","self":"https://a.klaviyo.com/api/events/32CLkDXR68M/relationships/profile/"}}}