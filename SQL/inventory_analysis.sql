/*
INVENTORY KPI ANALYSIS
Main Table: fact_inventory_cleaned
Dimension Tables:
- dim_product_cleaned
- dim_stores_cleaned
*/

use RetailAnalyticsDB;

---- KPIs ----

-- 1. Total Current Stock
select 
    SUM(current_stock) AS total_current_stock
FROM fact_inventory_cleaned;

-- 2. Total Stock Received
SELECT 
    SUM(stock_received) AS total_stock_received
FROM fact_inventory_cleaned;

-- 3. Total Stock Sold
SELECT 
    SUM(stock_sold) AS total_stock_sold
FROM fact_inventory_cleaned;

-- 4. Average Current Stock per Product
select 
    round(
        sum(current_stock) * 1.0 / count(distinct product_id), 2) as avg_current_stock_per_product
FROM fact_inventory_cleaned;

-- 5. Stock Received vs Stock Sold
SELECT 
    SUM(stock_received) AS total_stock_received,
    SUM(stock_sold) AS total_stock_sold,
    SUM(stock_received) - SUM(stock_sold) AS remaining_stock_difference
FROM fact_inventory_cleaned;


---------- Stock Movement Visibility ----------

-- 1. Inventory by Store
SELECT 
    fi.store_id,
    ds.store_name,
    ds.city,
    ds.region,
    SUM(fi.current_stock) AS total_current_stock,
    SUM(fi.stock_received) AS total_stock_received,
    SUM(fi.stock_sold) AS total_stock_sold
FROM fact_inventory_cleaned fi
JOIN dim_stores_cleaned ds
    ON fi.store_id = ds.store_id
GROUP BY 
    fi.store_id,
    ds.store_name,
    ds.city,
    ds.region
ORDER BY total_current_stock DESC;

-- 2. Inventory by Product Category
SELECT 
    dp.category,
    SUM(fi.current_stock) AS total_current_stock,
    SUM(fi.stock_received) AS total_stock_received,
    SUM(fi.stock_sold) AS total_stock_sold
FROM fact_inventory_cleaned fi
JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id
GROUP BY dp.category
ORDER BY total_current_stock DESC;

-- 3. Inventory Movement Distribution
select
    stock_movement,
    COUNT(*) AS total_products,
    SUM(current_stock) AS total_current_stock,
    SUM(stock_sold) AS total_stock_sold
FROM fact_inventory_cleaned
GROUP BY stock_movement
ORDER BY total_stock_sold DESC;



---------- Fast-Moving Inventory Items ----------

-- 4. Top Fast-Moving Products
SELECT TOP 10
    dp.product_name,
    dp.category,
    fi.stock_movement,
    fi.selling_rate,
    fi.stock_sold,
    fi.current_stock
FROM fact_inventory_cleaned fi
JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id
WHERE fi.stock_movement = 'Fast Moving'
ORDER BY fi.stock_sold DESC;

---------- Low-Performing / Dead Stock Products ----------

--5. Dead Stock Risk Products
SELECT 
    dead_stock,
    COUNT(*) AS total_products,
    SUM(current_stock) AS total_current_stock
FROM fact_inventory_cleaned
GROUP BY dead_stock
ORDER BY total_current_stock DESC;

-- 6. Top Dead Stock Products
SELECT TOP 10
    dp.product_name,
    dp.category,
    fi.dead_stock,
    fi.current_stock,
    fi.stock_sold
FROM fact_inventory_cleaned fi
JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id
WHERE fi.dead_stock = 'Dead Stock'
ORDER BY fi.current_stock DESC;

-- 7. Inventory Seasonality Analysis
SELECT 
    inventory_year,
    inventory_quarterly,
    COUNT(*) AS total_inventory_records,
    SUM(stock_received) AS total_stock_received,
    SUM(stock_sold) AS total_stock_sold,
    SUM(current_stock) AS total_current_stock
FROM fact_inventory_cleaned
GROUP BY inventory_year, inventory_quarterly
ORDER BY inventory_quarterly;

-- 8. Q4 High Demand Inventory Analysis
SELECT 
    inventory_year,
    inventory_quarterly,
    stock_movement,
    COUNT(*) AS total_products,
    SUM(stock_sold) AS total_stock_sold
FROM fact_inventory_cleaned
WHERE inventory_quarterly = 'Q4'
GROUP BY inventory_year, inventory_quarterly, stock_movement
ORDER BY total_stock_sold DESC;




---------- Stockout Prevention / Procurement Planning ----------

--9. Products Requiring Procurement Attention
SELECT 
    dp.product_name,
    dp.category,
    SUM(fi.stock_sold) AS total_stock_sold,
    SUM(fi.current_stock) AS total_current_stock,
    CASE
        WHEN SUM(fi.current_stock) < SUM(fi.stock_sold) * 0.25 THEN 'High Stockout Risk'
        WHEN SUM(fi.current_stock) < SUM(fi.stock_sold) * 0.50 THEN 'Medium Stockout Risk'
        ELSE 'Normal'
    END AS procurement_priority
FROM fact_inventory_cleaned fi
JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id
GROUP BY fi.product_id, dp.product_name, dp.category
ORDER BY total_stock_sold DESC;



