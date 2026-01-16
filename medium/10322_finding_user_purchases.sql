/* -----------------------------------------------------------------------
PROBLEM: Finding User Purchases
SOURCE: StrataScratch
ID: 10322
DIFFICULTY: Medium
-----------------------------------------------------------------------

DESCRIPTION:
Identify returning active users by finding users who made a second purchase 
within 1 to 7 days after their first purchase. 
- Ignore same-day purchases. 
- Output a list of these user_ids.

OUTPUT:
- user_id
*/

-- SOLUTION START --

WITH first_purchase AS (
    SELECT 
        user_id,
        MIN(created_at) AS fdate
    FROM amazon_transactions
    GROUP BY user_id
)

SELECT DISTINCT 
    a.user_id
FROM first_purchase a
JOIN amazon_transactions b 
    ON a.user_id = b.user_id 
    AND DATEDIFF(b.created_at, a.fdate) BETWEEN 1 AND 7;
