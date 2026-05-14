# Data Dictionary — Retail Sales & Inventory Analytics Project

## Overview

This document describes the structure, meaning, and usage of all datasets used in the Retail Sales & Inventory Analytics project.


# 1. fact_orders

### Description
Contains transactional sales order data.

- order_id → Unique identifier for each order
- order_date → Date when order was placed
- customer_id → Unique customer identifier
- product_id → Unique product identifier
- store_id → Unique store identifier
- quantity → Number of units sold
- sales_amount → Total sales value of the order
- discount → Discount applied on the order
- payment_method → Mode of payment used
- sales_channel → Online or Offline sales channel


# 2. fact_inventory

### Description
Contains inventory stock movement and availability data.

- inventory_id → Unique inventory transaction ID
- product_id → Unique product identifier
- store_id → Unique store identifier
- stock_received → Quantity received in inventory
- stock_sold → Quantity sold
- stock_remaining → Remaining stock quantity
- inventory_date → Inventory update date
- reorder_level → Minimum stock threshold


# 3. dim_products

### Description
Contains product master information.

- product_id → Unique product identifier
- product_name → Product name
- category → Product category
- sub_category → Product sub-category
- brand → Product brand
- unit_price → Selling price per unit
- cost_price → Product cost price


# 4. dim_customers

### Description
Contains customer demographic and profile information.

- customer_id → Unique customer identifier
- customer_name → Customer full name
- gender → Customer gender
- age → Customer age
- city → Customer city
- state → Customer state
- membership_type → Loyalty or membership category


# 5. dim_stores

### Description
Contains store location and operational information.

- store_id → Unique store identifier
- store_name → Store name
- city → Store city
- state → Store state
- region → Store region
- store_type → Online or physical store


# 6. dim_date

### Description
Contains calendar and date-related attributes.

- date → Calendar date
- day → Day of month
- month → Month name
- quarter → Quarter of year
- year → Year
- weekday → Day name
- week_number → Week number