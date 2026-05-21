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
-------------------------------------------------------------------------------------------------------------
-- Rows count validation
SELECT COUNT(*) AS total_rows FROM dim_customer_cleaned;
SELECT COUNT(*) AS total_rows FROM dim_product_cleaned;
SELECT COUNT(*) AS total_rows FROM dim_stores_cleaned;
SELECT COUNT(*) AS total_rows FROM dim_date_cleaned;
SELECT COUNT(*) AS total_rows FROM fact_inventory_cleaned;
SELECT COUNT(*) AS total_rows FROM fact_order_cleaned;

-- Exploration of data
SELECT TOP 5 * FROM dim_customer_cleaned;
SELECT TOP 5 * FROM dim_product_cleaned;
SELECT TOP 5 * FROM dim_stores_cleaned;
SELECT TOP 5 * FROM dim_date_cleaned;
SELECT TOP 5 * FROM fact_inventory_cleaned;
SELECT TOP 5 * FROM fact_order_cleaned;

-- Foreign key matching checks
SELECT DISTINCT product_id
FROM fact_order_cleaned
WHERE product_id NOT IN (SELECT product_id FROM dim_product_cleaned);

SELECT DISTINCT customer_id
FROM fact_order_cleaned
WHERE customer_id NOT IN (SELECT customer_id FROM dim_customer_cleaned);

SELECT DISTINCT store_id
FROM fact_order_cleaned
WHERE store_id NOT IN (SELECT store_id FROM dim_stores_cleaned);

SELECT DISTINCT product_id
FROM fact_inventory_cleaned
WHERE product_id NOT IN (SELECT product_id FROM dim_product_cleaned);

SELECT DISTINCT store_id
FROM fact_inventory_cleaned
WHERE store_id NOT IN (SELECT store_id FROM dim_stores_cleaned);

---Check the product_id and customer_id which is present in fact tables but not in dimension table 
SELECT *
FROM dim_product_cleaned
WHERE product_id = 'PROD0031';

SELECT *
FROM fact_order_cleaned
WHERE product_id = 'PROD0031';

SELECT *
FROM dim_customer_cleaned
WHERE customer_id = 'CUST00011';

SELECT *
FROM fact_order_cleaned
WHERE customer_id = 'CUST00011';

-- Inserting the value which is present in fact tables but not in dimension tables
INSERT INTO dim_product_cleaned (
    product_id, category, sub_category, brand, cost_price, selling_price, 
    selling_price_bucket, Category_Price, product_name
)
VALUES (
    'PROD0031', 'Unknown', 'Unknown', 'Unknown', 0, 0, 'Unknown', 'Unknown', 'Unknown Product'
);

INSERT INTO dim_customer_cleaned (
    customer_id, customer_name, city, state, loyalty_status, signup_date
)
VALUES (
    'CUST00011', 'Unknown Customer', 'Unknown', 'Unknown', 'Unknown', '2000-01-01'
);


-- Primary key constraints

ALTER TABLE dim_customer_cleaned
ADD CONSTRAINT PK_dim_customer PRIMARY KEY (customer_id);

ALTER TABLE dim_product_cleaned
ADD CONSTRAINT PK_dim_product PRIMARY KEY (product_id);

ALTER TABLE dim_stores_cleaned
ADD CONSTRAINT PK_dim_stores PRIMARY KEY (store_id);

ALTER TABLE dim_date_cleaned
ADD CONSTRAINT PK_dim_date PRIMARY KEY (full_date);

ALTER TABLE fact_order_cleaned
ADD CONSTRAINT PK_fact_order PRIMARY KEY (order_id);

ALTER TABLE fact_inventory_cleaned
ADD CONSTRAINT PK_fact_inventory PRIMARY KEY (inventory_id);


-- Foreign key constraints

ALTER TABLE fact_order_cleaned
ADD CONSTRAINT FK_fact_order_product
FOREIGN KEY (product_id)
REFERENCES dim_product_cleaned(product_id);

ALTER TABLE fact_order_cleaned
ADD CONSTRAINT FK_fact_order_customer
FOREIGN KEY (customer_id)
REFERENCES dim_customer_cleaned(customer_id);

ALTER TABLE fact_order_cleaned
ADD CONSTRAINT FK_fact_order_store
FOREIGN KEY (store_id)
REFERENCES dim_stores_cleaned(store_id);

ALTER TABLE fact_inventory_cleaned
ADD CONSTRAINT FK_fact_inventory_product
FOREIGN KEY (product_id)
REFERENCES dim_product_cleaned(product_id);

ALTER TABLE fact_inventory_cleaned
ADD CONSTRAINT FK_fact_inventory_store
FOREIGN KEY (store_id)
REFERENCES dim_stores_cleaned(store_id);


/*
1. Imported cleaned fact and dimension tables into SQL Server using Flat File Import Wizard.
2. Performed data validation checks including:
   * Row count verification
   * Duplicate primary key checks
   * Foreign key matching validation
3. Identified foreign key mismatches between fact and dimension tables:
   * Missing product_id: PROD0031
   * Missing customer_id: CUST00011
4. Investigated unmatched records using validation queries on dimension and fact tables.
5. Verified that missing IDs were not present in corresponding dimension tables.
6. Resolved referential integrity issue by inserting placeholder/master records for missing product and customer IDs into dimension tables.
7. Handled NOT NULL constraint issue in signup_date column by assigning default date values during data correction process.
8. Re-ran foreign key validation queries to confirm successful resolution of unmatched records before applying relationship constraints.
*/