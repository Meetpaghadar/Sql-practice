-- Flag days where a product’s revenue deviates by
-- ±200% from its 7-day moving average.


WITH cte AS (
    SELECT *,
   AVG(revenue) OVER (
   PARTITION BY product_id
   ORDER BY sales_date
 ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING  ) AS moving_avg_7d
    FROM sales
)

SELECT
product_id, sales_date, revenue, moving_avg_7d,
  CASE   WHEN revenue > moving_avg_7d * 3  THEN 'HIGH_ANOMALY'
    WHEN revenue < moving_avg_7d / 3  THEN 'LOW_ANOMALY' ELSE 'NORMAL'  END AS flag
FROM cte
WHERE moving_avg_7d IS NOT NULL;
