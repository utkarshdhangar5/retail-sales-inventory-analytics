/*
INVENTORY KPIs & ANALYSIS
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
SELECT
    stock_movement,
    COUNT(*) AS total_records,
    SUM(stock_received) AS total_stock_received,
    SUM(stock_sold) AS total_stock_sold,
    SUM(current_stock) AS total_current_stock,
    ROUND(AVG(selling_rate), 2) AS avg_selling_rate
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

-- 5. Top Dead Stock Products
SELECT TOP 20
    fi.product_id,
    dp.product_name,
    dp.category,
    fi.stock_sold,
    fi.current_stock,
    fi.selling_rate,
    fi.dead_stock,
    fi.stock_movement
FROM fact_inventory_cleaned fi
LEFT JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id
WHERE fi.dead_stock = 'Dead Stock'
   OR fi.stock_movement = 'Slow Moving'
ORDER BY fi.current_stock DESC;


---------- Q4 and seasonality analysis ----------

-- 6. Inventory Seasonality Analysis
SELECT TOP 20
    fi.product_id,
    dp.product_name,
    dp.category,
    fi.stock_sold,
    fi.current_stock,
    fi.reorder_level,
    fi.selling_rate,
    fi.stock_movement
FROM fact_inventory_cleaned fi
LEFT JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id
WHERE fi.inventory_quarterly = 'Q4'
  AND fi.stock_movement = 'Fast Moving'
ORDER BY fi.stock_sold DESC;

-- 7. Q4 High Demand Inventory Analysis
SELECT
    inventory_quarterly,
    SUM(stock_sold) AS total_stock_sold,
    SUM(stock_received) AS total_stock_received,
    SUM(current_stock) AS total_current_stock,
    ROUND(AVG(selling_rate), 2) AS avg_selling_rate
FROM fact_inventory_cleaned
GROUP BY inventory_quarterly
ORDER BY inventory_quarterly;




---------- Stockout Prevention / Procurement Planning ----------

--8. Products Requiring Procurement Attention
SELECT TOP 20
    dp.product_name,
    dp.category,
    fi.stock_sold,
    fi.current_stock,
    fi.reorder_level,
    fi.stock_movement,
    CASE
        WHEN fi.current_stock <= fi.reorder_level
            THEN 'High Priority'
        WHEN fi.stock_movement = 'Fast Moving'
             AND fi.current_stock <= fi.reorder_level * 2
            THEN 'Medium Priority'

        ELSE 'Normal'
    END AS procurement_priority

FROM fact_inventory_cleaned fi
LEFT JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id

WHERE 
    fi.current_stock <= fi.reorder_level
    OR (
        fi.stock_movement = 'Fast Moving'
        AND fi.current_stock <= fi.reorder_level * 2
    )

ORDER BY 
    CASE
        WHEN fi.current_stock <= fi.reorder_level THEN 1
        ELSE 2
    END,
    fi.stock_sold DESC;



----- Procurement Recommendation Summary -----
SELECT
    CASE
        WHEN current_stock <= reorder_level
            THEN 'Urgent Reorder Required'

        WHEN stock_movement = 'Fast Moving'
             AND current_stock <= reorder_level * 2
            THEN 'Increase Procurement Planning'

        WHEN dead_stock = 'Dead Stock'
            THEN 'Avoid Procurement / Run Clearance'

        WHEN stock_movement = 'Slow Moving'
            THEN 'Reduce Future Procurement'

        ELSE 'Maintain Normal Procurement'
    END AS procurement_recommendation,

    COUNT(*) AS total_products,
    SUM(stock_sold) AS total_stock_sold,
    SUM(current_stock) AS total_current_stock

FROM fact_inventory_cleaned

GROUP BY
    CASE
        WHEN current_stock <= reorder_level
            THEN 'Urgent Reorder Required'

        WHEN stock_movement = 'Fast Moving'
             AND current_stock <= reorder_level * 2
            THEN 'Increase Procurement Planning'

        WHEN dead_stock = 'Dead Stock'
            THEN 'Avoid Procurement / Run Clearance'

        WHEN stock_movement = 'Slow Moving'
            THEN 'Reduce Future Procurement'

        ELSE 'Maintain Normal Procurement'
    END

ORDER BY total_products DESC;



/* Insights

1. Store-wise Insights -
- Ahmedabad, Chennai, and Kolkata are the top 3 hubs by stock sold, showing strongest inventory movement.
- West, South, and East regions all have strong-performing retail hubs, so demand is not limited to one region.
- Mumbai and Bengaluru show comparatively lower stock sold among major metro hubs, so their performance needs review.

2. Category-wise Insights -
- Beauty and Fashion are the strongest categories with the highest stock sold and stock received.
- Electronics performs well but trails behind Beauty and Fashion in total stock movement.
- The “Unknown” category is very small and should be fixed as a data quality issue.

3. Stock Movement Insights -
- Fast-moving products dominate inventory performance with the highest stock sold and selling rate.
- Slow-moving products have low sales but high remaining stock, increasing dead stock risk.
- Mid-moving products are stable but need monitoring to avoid becoming slow-moving stock.

4. Fast-Moving Product Insights -
- Lakme, Puma, Reebok, Apple, Dell, Nike, Philips, and Loreal products show strong demand.
- Many top fast-moving products sold 299 units, meaning they are key products for replenishment planning.
- Products like Lakme Makeup have very low current stock, so they need priority restocking.

5. Dead Stock & Low-Performing Product Insights - 
- Dead stock products may require discount campaigns, bundle offers, or procurement reduction strategies to improve 
  inventory utilization.
- Multiple Electronics, Home & Kitchen, and Fashion products show high dead stock risk due to high remaining inventory
  and lower selling rates.
- Slow-moving products like Lakme Makeup, Philips Furniture, and Dell Accessories may increase holding costs and require 
  discount or clearance strategies.

6. Fast-Moving Product Insights - 
- Beauty, Fashion, Sports, and Electronics categories contain the highest-performing fast-moving products.
- Products from Lakme, Nike, Reebok, Samsung, Apple, and Prestige show strong customer demand and high inventory turnover.
- Several fast-moving products have low remaining stock, indicating potential stockout risk and the need for timely replenishment.

7. Quarterly Inventory Insights -
- Q3 showed the highest inventory movement and stock sold, indicating peak seasonal demand.
- Q4 recorded the lowest inventory activity among all quarters.
- Inventory turnover remained stable across all quarters with similar selling rates.

8. High Procurement Priority Insights -
- Multiple fast-moving Beauty, Electronics, Sports, and Fashion products have critically low stock levels.
- Lakme Makeup, Samsung Mobiles, Reebok products, and Puma Footwear require urgent replenishment to prevent stockouts.
- Beauty and Electronics categories dominate high-priority procurement demand.

9. Procurement Recommendation Summary - 
- Most products fall under “Avoid Procurement / Run Clearance,” indicating high dead stock and excess inventory levels.
- A majority of products maintain stable inventory under “Maintain Normal Procurement.”
- Products marked as “Urgent Reorder Required” face immediate stockout risk due to very low current stock.
- “Increase Procurement Planning” products are fast-moving items requiring proactive replenishment planning.
- Very few products fall under “Reduce Future Procurement,” indicating that only a small portion of inventory 
  is significantly slow-moving.

*/




