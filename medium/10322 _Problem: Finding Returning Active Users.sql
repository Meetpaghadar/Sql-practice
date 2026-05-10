-- =========================================================
-- 🛒 Problem: Finding Returning Active Users
-- Difficulty: Medium
-- ID: 10322
-- Last Updated: April 2026
-- =========================================================

/*
📌 Problem Statement:
Identify users who made a second purchase within 1 to 7 days
after their first purchase. Ignore same-day purchases.

Return a list of user_ids.
---
 SQL Solution:
*/

WITH cte AS (
SELECT
user_id,
created_at,
    RANK() OVER (
        PARTITION BY user_id 
        ORDER BY created_at
    ) AS rnk,
    DATEDIFF(
        LEAD(created_at) OVER (
            PARTITION BY user_id 
            ORDER BY created_at
        ),
        created_at
    ) AS next_order
FROM amazon_transactions
)

SELECT user_id
FROM cte
WHERE rnk = 1
AND next_order BETWEEN 1 AND 7;

-- =========================================================
-- 🧾 Summary:
-- Finds users whose second purchase occurs within 7 days
-- of their first purchase (excluding same-day purchases).
-- =========================================================
