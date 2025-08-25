# ClickHouse Cloud Tilla

A comprehensive data analytics solution using ClickHouse for e-commerce data aggregation and analysis.

## Overview

This repository contains SQL schemas and scripts for creating and managing data warehousing solutions in ClickHouse Cloud. It includes curated datasets and analytics layers for multiple data sources including:

- **GA4 (Google Analytics 4)** - Website analytics and user behavior tracking
- **Klaviyo** - Email marketing campaign performance and customer engagement
- **Shopify** - E-commerce orders, customers, and inventory management

## Project Structure

```
.
├── curated_datasets/          # Base materialized views from raw data
│   ├── data_ga4/             # Google Analytics 4 curated datasets
│   ├── data_klaviyo/         # Klaviyo marketing data
│   └── data_shopify/         # Shopify e-commerce data
│
├── analytics_datasets/        # Aggregated analytics views
│   └── klaviyo_analytics/    # Klaviyo performance analytics
│
└── provisioning_flow.sql     # Main provisioning script
```

## Curated Datasets

### GA4 Analytics
- Daily/Weekly/Monthly active users
- Device and location analytics
- Traffic sources and page performance
- Website overview metrics

### Klaviyo Marketing
- Campaign performance tracking
- Email event tracking
- Customer profiles and lifecycle
- Marketing metrics and flows

### Shopify E-commerce
- Order and fulfillment tracking
- Customer management
- Inventory levels and items
- Abandoned checkouts
- Discount codes and refunds

## Analytics Layers

### Klaviyo Analytics
- **Campaign Performance** - Email campaign metrics and engagement rates
- **Attribution Summary** - UTM-based attribution tracking
- **Customer Lifecycle** - CLV segmentation and churn analysis
- **Daily Event Summary** - Aggregated daily event metrics
- **Segment Performance** - Marketing segment analysis
- **Hourly Engagement** - Time-based engagement patterns

## Backfill Scripts

Each dataset includes backfill scripts in the `backdate_mv/` subdirectories for populating historical data.

## Setup Instructions

1. Ensure you have access to a ClickHouse Cloud instance
2. Configure your connection settings
3. Run the provisioning scripts in the following order:
   - First, execute curated dataset schemas
   - Then, run analytics dataset schemas
   - Finally, execute backfill scripts as needed

## Requirements

- ClickHouse Cloud instance
- Appropriate permissions for creating databases and tables
- Raw data sources configured (GA4, Klaviyo, Shopify APIs)

## Data Flow

```
Raw Data Sources → Curated Datasets (Materialized Views) → Analytics Datasets (Aggregated Views)
```

## License

This project is proprietary and confidential.

## Contact

For questions or support, please contact the data engineering team.