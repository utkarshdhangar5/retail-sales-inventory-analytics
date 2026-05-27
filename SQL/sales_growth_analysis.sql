
/*

MoM & YoY Growth Trend Analysis

table used: fact_orders_cleaned,
            dim_date_cleaned,
            dim_store_cleaned
*/

use RetailAnalyticsDB;


--1. MoM Growth Analysis
WITH monthly_sales AS (
    SELECT
        dd.year,
        dd.month,
        SUM(fo.sales_amount) AS total_revenue
    FROM fact_order_cleaned fo
    JOIN dim_date_cleaned dd
        ON fo.order_date = dd.full_date
    GROUP BY
        dd.year,
        dd.month
),
growth_calc AS (
    SELECT
        year,
        month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY year, month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    year,
    month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue) * 100.0
        / NULLIF(previous_month_revenue, 0), 2
    ) AS mom_growth_percent
FROM growth_calc
ORDER BY year, month;


--2. YoY Growth Analysis
WITH yearly_sales AS (
    SELECT
        dd.year,
        SUM(fo.sales_amount) AS total_revenue
    FROM fact_order_cleaned fo
    JOIN dim_date_cleaned dd
        ON fo.order_date = dd.full_date
    GROUP BY dd.year
),
growth_calc AS (
    SELECT
        year,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY year
        ) AS previous_year_revenue
    from yearly_sales
 )
 SELECT
    year,
    total_revenue,
    previous_year_revenue,
    ROUND(
        (total_revenue - previous_year_revenue) * 100.0
        / NULLIF(previous_year_revenue, 0), 2
    ) AS yoy_growth_percent
FROM growth_calc
ORDER BY year;


--3. Regional YoY Growth Trend
WITH regional_sales AS (
    SELECT
        ds.region,
        dd.year AS sales_year,
        SUM(fo.sales_amount) AS total_revenue
    FROM fact_order_cleaned fo
    JOIN dim_date_cleaned dd
        ON fo.order_date = dd.full_date
    JOIN dim_stores_cleaned ds 
        ON fo.store_id = ds.store_id
    GROUP BY
        ds.region,
        dd.year
),
growth_calc AS (
    SELECT
        region,
        sales_year,
        total_revenue,
        LAG(total_revenue) OVER (
            PARTITION BY region
            ORDER BY sales_year
        ) AS previous_year_revenue
    FROM regional_sales
)
SELECT
    region,
    sales_year,
    total_revenue,
    ISNULL(previous_year_revenue, 0) AS previous_year_revenue,

    CASE
        WHEN previous_year_revenue IS NULL THEN 0
        ELSE ROUND(
            (total_revenue - previous_year_revenue) * 100.0
            / NULLIF(previous_year_revenue, 0),
            2
        )
    END AS yoy_growth_percent

FROM growth_calc
ORDER BY region, sales_year;


/* Insights

1. MoM - 
- Revenue peaked consistently during October, November, and December, showing strong festive season demand.
- November and December recorded the highest MoM growth across both years.
- Q4 remains the most critical period for inventory planning and revenue generation.
- Significant revenue drops were observed after peak sales periods, especially in February and September, showing post-season 
  sales slowdown.

2. YoY -
- Total revenue declined slightly by 1.77% in 2025 compared to 2024.
- Despite stable sales performance, the business experienced a small year-over-year slowdown in overall revenue growth.
- The decline indicates the need for stronger sales and inventory strategies to maintain long-term revenue growth.

3. Regional YoY -
- All regions experienced a slight YoY revenue decline in 2025 compared to 2024.
- North region remained the highest revenue-generating region despite a minor 0.53% decline.
- East region recorded the largest revenue drop at 6.1%, indicating weaker regional sales performance.
- South and West regions maintained relatively stable revenue with only small YoY declines.
- Overall regional performance remained stable, but growth recovery strategies may be needed to improve 2025 sales performance.

/*
