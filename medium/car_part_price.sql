-- ============================================
-- Car Part Price Change Analysis
-- ============================================

-- Objective:
-- Calculate year-over-year price change for each car part.
-- - Remove duplicates first
-- - Compare with previous available year (not necessarily consecutive)
-- - First occurrence should return NULL


WITH dedup AS (
    SELECT DISTINCT
        car_part_id,
        model_year,
        price
    FROM car_parts
),
price_history AS (
    SELECT
        car_part_id,
        model_year,
        price,
        LAG(price) OVER (
            PARTITION BY car_part_id
            ORDER BY model_year
        ) AS prev_price
    FROM dedup
)
SELECT
    car_part_id,
    model_year,
    price,
    prev_price,
    price - prev_price AS price_change
FROM price_history
ORDER BY car_part_id, model_year;
