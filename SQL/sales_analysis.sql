
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

select * from fact_order_cleaned

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

-- Average discount percent and total discount
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


/*
SALES TREND & TIME ANALYSIS
Using dim_date_cleaned for date intelligence
*/

-- 1. Daily Revenue Trend
select 
    dd.full_date,
    count(distinct fo.order_id) as total_orders,
    sum(sales_amount) as daily_revenue
from fact_order_cleaned fo
join dim_date_cleaned dd
on fo.order_date = dd.full_date
group by dd.full_date
order by dd.full_date;

-- 2. Monthly Revenue Trend
select 
    dd.month,
    dd.year,
    count(distinct fo.order_id) as total_orders,
    sum(fo.sales_amount) as monthly_revenue
from fact_order_cleaned fo
join dim_date_cleaned dd
on fo.order_date = dd.full_date
GROUP BY dd.month, dd.year
ORDER BY dd.year, monthly_revenue DESC;

-- 3. Quarterly Revenue Trend
SELECT 
    dd.quarter,
    dd.year,
    count(distinct fo.order_id) as total_orders,
    SUM(fo.sales_amount) AS total_revenue
FROM fact_order_cleaned fo
JOIN dim_date_cleaned dd
    ON fo.order_date = dd.full_date
GROUP BY dd.quarter, dd.year
ORDER BY dd.year, dd.quarter;


-- 4. Weekday vs Weekend Sales
SELECT 
    dd.is_weekend,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    SUM(fo.sales_amount) AS total_revenue,
    SUM(fo.quantity) AS total_quantity_sold
FROM fact_order_cleaned fo
JOIN dim_date_cleaned dd
    ON fo.order_date = dd.full_date
GROUP BY dd.is_weekend
ORDER BY total_revenue DESC;

-- 5. Sales by Day Name
SELECT 
    dd.day_name,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    SUM(fo.sales_amount) AS total_revenue
FROM fact_order_cleaned fo
JOIN dim_date_cleaned dd
    ON fo.order_date = dd.full_date
GROUP BY dd.day_name
ORDER BY total_revenue DESC;


-- 6. Highest Revenue Months
SELECT TOP 6
    dd.month,
    dd.year,
    SUM(fo.sales_amount) AS total_revenue
FROM fact_order_cleaned fo
JOIN dim_date_cleaned dd
    ON fo.order_date = dd.full_date
GROUP BY dd.month, dd.year, dd.month_number
ORDER BY total_revenue DESC;

-- Peak Purchasing Hours
SELECT 
    hourly_bucket,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    round(SUM(sales_amount),2) AS total_revenue
FROM fact_order_cleaned
GROUP BY hourly_bucket
ORDER BY total_revenue DESC;

/* Insights

1. Q4 generated the highest revenue in both years, contributing arund 259M revenue in 2024 and 2025,
   while October and November are the top-performing months with revenue above 85M. This indicates
   strong seasnal demand during the festive and holiday period. The business should do marketing campaign
   and  operational readiness before Q4 to maximize their revenue opportunities.

2. Weekdays generated higher overall revenue (861M) compared to weekends (446M), 
   showing consistent customer activity during working days. However, Saturday (224M) and Sunday (221M) 
   individually recorded the highest daily revenues, highlighting strong weekend purchasing behavior.

3. Evening hours generated the highest revenue (528M) and order volume, followed by Afternoon sales (436M).
   This shows that customers are most active during evening hours, making it the peak operational.
   while mornings contributed comparatively lower revenue. The business should prioritize staffing,
   inventory availability, customer support, and promotional campaigns during evening hours 
   to enhance customer experience.
*/

