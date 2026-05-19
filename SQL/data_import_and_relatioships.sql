---------------------- Creating Database --------------------
CREATE DATABASE RetailAnalyticsDB;

USE RetailAnalyticsDB; 

/*
PROJECT: Retail Sales & Inventory Analytics

STAR SCHEMA DESIGN

FACT TABLES:
1. fact_orders
   - Stores sales/order transactions
   - Used for sales KPIs, revenue analysis, customer analysis, and product performance

2. fact_inventory
   - Stores inventory/stock records
   - Used for inventory tracking, stock movement, dead stock analysis, and stock availability

DIMENSION TABLES:
1. dim_products
   - Product-related details
   - Connected using product_id

2. dim_customers
   - Customer-related details
   - Connected using customer_id

3. dim_stores
   - Store/location-related details
   - Connected using store_id

4. dim_date
   - Date-related details
   - Connected using date columns

RELATIONSHIP PLAN:

fact_orders.product_id   -> dim_products.product_id
fact_orders.customer_id  -> dim_customers.customer_id
fact_orders.store_id     -> dim_stores.store_id
fact_orders.order_date   -> dim_date.date

fact_inventory.product_id -> dim_products.product_id
fact_inventory.store_id   -> dim_stores.store_id
fact_inventory.stock_date -> dim_date.date

STAR SCHEMA FLOW:

                dim_customers
                       |
                       |
dim_products ---- fact_orders ---- dim_stores
                       |
                       |
                   dim_date


                dim_products
                       |
                       |
                fact_inventory
                       |
                       |
                   dim_stores
                       |
                       |
                    dim_date

NOTES:
- Tables will be imported using SQL Server Flat File Import Wizard.
- Relationships and constraints will be applied after successful data import.
- Star schema is designed for Power BI reporting and KPI analysis.
*/

/*
DATABASE STRUCTURE PLAN

Database Name:
RetailAnalyticsDB

Schemas:
- dbo.fact_orders
- dbo.fact_inventory
- dbo.dim_products
- dbo.dim_customers
- dbo.dim_stores
- dbo.dim_date
*/

/*
PK/FK Planning Section

PRIMARY KEY PLAN
fact_orders      -> order_id
fact_inventory   -> inventory_id
dim_products     -> product_id
dim_customers    -> customer_id
dim_stores       -> store_id
dim_date         -> date

FOREIGN KEY PLAN
fact_orders.product_id    -> dim_products.product_id
fact_orders.customer_id   -> dim_customers.customer_id
fact_orders.store_id      -> dim_stores.store_id

fact_inventory.product_id -> dim_products.product_id
fact_inventory.store_id   -> dim_stores.store_id
*/