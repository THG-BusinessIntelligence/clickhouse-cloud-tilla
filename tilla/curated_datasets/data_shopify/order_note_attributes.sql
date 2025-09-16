-- Order note attributes flattened table
-- Extracts custom field data from orders
CREATE VIEW data_shopify.order_note_attributes
AS
WITH note_attributes_expanded AS (
    SELECT 
        id AS order_id,
        created_at AS order_created_at,
        arrayJoin(
            arrayEnumerate(JSONExtractArrayRaw(assumeNotNull(note_attributes)))
        ) AS attribute_index,
        JSONExtractArrayRaw(assumeNotNull(note_attributes)) AS attributes_array
    FROM raw_shopify.orders
    WHERE id IS NOT NULL 
      AND note_attributes IS NOT NULL
      AND length(note_attributes) > 2
)
SELECT 
    order_id,
    order_created_at,
    attribute_index AS position,
    JSONExtractString(attributes_array[attribute_index], 'name') AS attribute_name,
    JSONExtractString(attributes_array[attribute_index], 'value') AS attribute_value
FROM note_attributes_expanded;