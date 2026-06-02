
-- .Find the top 3 products with the steepest positive sales trend over the last 90 days.

WITH ranked AS (
    SELECT
        product_id,
        sale_date,
        sales,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY sale_date
        ) AS rn_start,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY sale_date DESC
        ) AS rn_end
    FROM sales
    WHERE sale_date >= CURRENT_DATE - INTERVAL '90 days'
),

start_end AS (
    SELECT
        product_id,
-- MAX() u beauty , collaspe to single row
        MAX(CASE WHEN rn_start = 1 THEN sales END) AS start_sales,
        MAX(CASE WHEN rn_end = 1 THEN sales END) AS end_sales
    FROM ranked
    GROUP BY product_id
),

trend AS (
    SELECT
        product_id,
        start_sales,
        end_sales,
        (end_sales - start_sales) * 1.0 / 90 AS trend_score
    FROM start_end
)

SELECT *
FROM trend
WHERE trend_score > 0
ORDER BY trend_score DESC
LIMIT 3;
