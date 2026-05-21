
/*
SALES ANALYSIS - FACT ORDER BASED KPIs
Main Table: fact_order_cleaned
Dimension Tables Used:
- dim_product_cleaned
- dim_customer_cleaned
- dim_stores_cleaned
- dim_date_cleaned
*/

use RetailAnalyticsDB;

select top 5 * from fact_order_cleaned

-- 1. Total Sales Revenue
select 
    sum(sales_amount) as total_sales_revenue
from fact_order_cleaned;

-- 2. Total Orders
select 
    count(distinct order_id) as total_orders
from fact_order_cleaned;

-- 3. Total Quantity Sold
select 
    sum(quantity) as total_quantity_sold
from fact_order_cleaned;

-- 4. Average Revenue Per Order/ AOV
SELECT 
    round(sum(sales_amount) / count(distinct order_id),2) as avg_revenue_per_order
FROM fact_order_cleaned;

-- 5. Average Quantity Per Order
select 
    sum(quantity) / count(distinct order_id) as avg_quantity_per_order
from fact_order_cleaned;

-- 6. Revenue by Sales Channel
select
    sales_channel,
    count(distinct order_id) as total_orders,
    sum(sales_amount) as total_revenue
from fact_order_cleaned
group by sales_channel
order by total_revenue desc;

-- 7. Revenue by Payment Method
select 
    payment_method,
    count(distinct order_id) as total_orders,
    sum(sales_amount) as total_revenue
from fact_order_cleaned
group by payment_method
order by total_revenue desc;
