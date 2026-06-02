-- Write a query to find the top 3 products with the
-- highest revenue growth compared to the previous
-- month.

WITH monthly_revenue AS (
    SELECT
        product_id,
        DATE_TRUNC('month', order_date) AS month,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY 1,2
),
growth_cte AS (
    SELECT
        product_id,
        month,
        revenue -
        LAG(revenue) OVER (
            PARTITION BY product_id
            ORDER BY month
        ) AS growth
    FROM monthly_revenue
)
SELECT
    product_id,
    month,
    growth
FROM growth_cte
WHERE growth IS NOT NULL
ORDER BY growth DESC
LIMIT 3;
