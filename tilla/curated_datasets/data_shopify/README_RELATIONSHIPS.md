# Shopify Data Model - Table Relationships

## Overview
This document describes the normalized Shopify data model with proper foreign key relationships for AI agent reporting.

## Primary Tables and Keys

### Core Entities
1. **shop** - Store configuration (shop_id)
2. **customers** - Customer records (customer_id)
3. **orders** - Order transactions (order_id)
4. **locations** - Physical/virtual locations (id/location_id)
5. **countries** - Country reference data (id)

### Order-Related Tables
1. **order_line_items** - Order items (order_id, line_item_id)
2. **order_tax_lines** - Tax details (order_id, line_item_id, tax_title)
3. **order_discount** - Discount allocations (order_id, line_item_id, discount_application_index)
4. **order_payment_gateway** - Payment methods (order_id, gateway_name)
5. **order_agreements** - Sales agreements (order_id, agreement_id, sale_id)

### Refund Tables
1. **order_refund_line_items** - Refunded items (refund_id, refund_line_item_id)
2. **order_refund_transactions** - Refund transactions (refund_id, transaction_id)
3. **order_refund_adjustments** - Refund adjustments (refund_id, adjustment_id)

### Financial Tables
1. **transactions** - Financial transactions (transaction_id, order_id)
2. **price_rules** - Discount rules (price_rule_id)
3. **discount_codes** - Discount code instances (id, price_rule_id)

### Inventory Tables
1. **inventory_items** - Product inventory items (id)
2. **inventory_levels** - Stock levels (id, inventory_item_id, location_id)
3. **inventory_quantities** - Quantity tracking (id, inventory_item_id)

### Fulfillment Tables
1. **fulfillments** - Order fulfillments (id, order_id)
2. **fulfillment_line_items** - Fulfilled items (fulfillment_id, line_item_id)

### Customer Tables
1. **customers** - Customer master (customer_id)
2. **customer_address** - Customer addresses (id, customer_id)
3. **customer_journey_summary** - Journey overview (order_id) [DO NOT MODIFY]
4. **customer_journey_detail** - Journey details (order_id, visit_id) [DO NOT MODIFY]

### Abandoned Cart Tables
1. **abandoned_checkouts** - Abandoned carts (id)
2. **abandoned_checkouts_line_items** - Abandoned items (checkout_id, line_item_id)

## Key Relationships

### Order Relationships
- orders.customer_id → customers.customer_id
- orders.location_id → locations.id
- orders.shop_url → shop.shop_url

### Order Line Item Relationships
- order_line_items.order_id → orders.order_id
- order_tax_lines.order_id → orders.order_id
- order_discount.order_id → orders.order_id
- order_payment_gateway.order_id → orders.order_id

### Transaction Relationships
- transactions.order_id → orders.order_id
- transactions.parent_transaction_id → transactions.transaction_id (self-reference)
- transactions.location_id → locations.id

### Refund Relationships
- order_refund_line_items.order_id → orders.order_id (via refund)
- order_refund_transactions.refund_id → (implicit refund table)
- order_refund_adjustments.refund_id → (implicit refund table)

### Inventory Relationships
- inventory_levels.inventory_item_id → inventory_items.id
- inventory_levels.location_id → locations.id
- inventory_quantities.inventory_item_id → inventory_items.id

### Fulfillment Relationships
- fulfillments.order_id → orders.order_id
- fulfillments.location_id → locations.id
- fulfillment_line_items.fulfillment_id → fulfillments.id

### Customer Relationships
- customer_address.customer_id → customers.customer_id
- orders.customer_id → customers.customer_id

### Discount Relationships
- discount_codes.price_rule_id → price_rules.price_rule_id

## Reporting Optimizations for AI Agent

1. **Aggregated Counts**: Orders table includes pre-calculated counts (line_items_count, refunds_count, etc.)
2. **Flattened JSON**: Complex JSON fields are extracted into columns for easier querying
3. **Consistent Naming**: All foreign keys follow pattern: table_id (e.g., order_id, customer_id)
4. **Partitioning**: Tables partitioned by date for efficient time-based queries
5. **POPULATE**: All views use POPULATE to backfill historical data on creation

## Notes
- PII data has been excluded or hashed where necessary
- All tables include shop_url for multi-tenant filtering
- Timestamps are normalized to DateTime64 format
- JSON arrays are counted for quick aggregations without joins