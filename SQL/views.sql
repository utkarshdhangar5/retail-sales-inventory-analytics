-------------------------- VIEWS -----------------------

use RetailAnalyticsDB


--1. vw_monthly_sales_growth
CREATE VIEW vw_monthly_sales_growth AS
WITH monthly_sales AS (
    SELECT
        dd.year,
        dd.month,
        MIN(dd.full_date) AS month_start_date,
        SUM(fo.sales_amount) AS total_revenue
    FROM fact_order_cleaned fo
    JOIN dim_date_cleaned dd
        ON fo.order_date = dd.full_date
    GROUP BY dd.year, dd.month
),
growth_calc AS (
    SELECT
        year,
        month,
        month_start_date,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY year, month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    year,
    month,
    month_start_date,
    total_revenue,
    ISNULL(previous_month_revenue, 0) AS previous_month_revenue,
    CASE
        WHEN previous_month_revenue IS NULL THEN 0
        ELSE ROUND(
            (total_revenue - previous_month_revenue) * 100.0
            / NULLIF(previous_month_revenue, 0), 2
        )
    END AS mom_growth_percent
FROM growth_calc;


--2. vw_yearly_sales_growth
CREATE VIEW vw_yearly_sales_growth AS
WITH yearly_sales AS (
    SELECT
        dd.year,
        MIN(dd.full_date) AS year_start_date,
        SUM(fo.sales_amount) AS total_revenue
    FROM fact_order_cleaned fo
    JOIN dim_date_cleaned dd
        ON fo.order_date = dd.full_date
    GROUP BY dd.year
),
growth_calc AS (
    SELECT
        year,
        year_start_date,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY year
        ) AS previous_year_revenue
    FROM yearly_sales
)
SELECT
    year,
    year_start_date,
    total_revenue,
    ISNULL(previous_year_revenue, 0) AS previous_year_revenue,
    CASE
        WHEN previous_year_revenue IS NULL THEN 0
        ELSE ROUND(
            (total_revenue - previous_year_revenue) * 100.0
            / NULLIF(previous_year_revenue, 0), 2
        )
    END AS yoy_growth_percent
FROM growth_calc;



--3. vw_regional_yoy_growth
CREATE VIEW vw_regional_yoy_growth AS
WITH regional_sales AS (
    SELECT
        ds.region,
        dd.year,
        MIN(dd.full_date) AS year_start_date,
        SUM(fo.sales_amount) AS total_revenue
    FROM fact_order_cleaned fo
    JOIN dim_date_cleaned dd
        ON fo.order_date = dd.full_date
    JOIN dim_stores_cleaned ds
        ON fo.store_id = ds.store_id
    GROUP BY ds.region, dd.year
),
growth_calc AS (
    SELECT
        region,
        year,
        year_start_date,
        total_revenue,
        LAG(total_revenue) OVER (
            PARTITION BY region
            ORDER BY year
        ) AS previous_year_revenue
    FROM regional_sales
)
SELECT
    region,
    year,
    year_start_date,
    total_revenue,
    ISNULL(previous_year_revenue, 0) AS previous_year_revenue,
    CASE
        WHEN previous_year_revenue IS NULL THEN 0
        ELSE ROUND(
            (total_revenue - previous_year_revenue) * 100.0
            / NULLIF(previous_year_revenue, 0), 2
        )
    END AS yoy_growth_percent
FROM growth_calc;



--4. vw_procurement_priority
CREATE VIEW vw_procurement_priority AS
SELECT
    fi.inventory_id,
    fi.product_id,
    fi.store_id,
    dp.product_name,
    dp.category,
    ds.store_name,
    ds.city,
    ds.region,
    fi.stock_sold,
    fi.current_stock,
    fi.reorder_level,
    fi.stock_movement,
    fi.dead_stock,
    CASE
        WHEN fi.current_stock <= fi.reorder_level
            THEN 'Urgent Reorder Required'

        WHEN fi.stock_movement = 'Fast Moving'
             AND fi.current_stock <= fi.reorder_level * 2
            THEN 'Increase Procurement Planning'

        WHEN fi.dead_stock = 'Dead Stock'
            THEN 'Avoid Procurement / Run Clearance'

        WHEN fi.stock_movement = 'Slow Moving'
            THEN 'Reduce Future Procurement'

        ELSE 'Maintain Normal Procurement'
    END AS procurement_recommendation
FROM fact_inventory_cleaned fi
LEFT JOIN dim_product_cleaned dp
    ON fi.product_id = dp.product_id
LEFT JOIN dim_stores_cleaned ds
    ON fi.store_id = ds.store_id;
    

SELECT *
FROM INFORMATION_SCHEMA.VIEWS;