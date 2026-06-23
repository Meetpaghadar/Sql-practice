/*
Problem Type:
Fill missing values using last known non-null value (Forward Fill / LOCF)
*/

WITH cte AS (
    SELECT *,
           1 AS test,
           CASE 
               WHEN category IS NOT NULL THEN 1 
               ELSE 0 
           END AS ct
    FROM brands
),

cte2 AS (
    SELECT *,
           SUM(ct) OVER (
               ORDER BY test 
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS ss
    FROM cte
)

SELECT *,
       FIRST_VALUE(category) OVER (
           PARTITION BY ss 
           ORDER BY test
       ) AS filled_category
FROM cte2;
