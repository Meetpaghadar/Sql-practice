/*
-----------------------------------------------------------------------------
Question : Apple Product Count
Qid : 10141
Description: 
    This query analyzes user demographics to understand device adoption rates 
    across different languages. It uses conditional aggregation to calculate 
    the number of users on specific Apple devices (MacBook Pro, iPhone 5s, 
    iPad Air) compared to the total user base for each language.

Key Concepts:
    - LEFT JOIN (assuming users might not have events, though INNER JOIN works if events are guaranteed)
    - Conditional Aggregation (CASE WHEN inside COUNT)
    - Data Deduplication (DISTINCT)
-----------------------------------------------------------------------------
*/

SELECT 
    u.language,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT CASE 
        WHEN e.device IN ('macbook pro', 'iphone 5s', 'ipad air') 
        THEN u.user_id 
        ELSE NULL 
    END) AS apple_device_users

FROM playbook_users u
JOIN playbook_events e 
    ON u.user_id = e.user_id
GROUP BY 
    u.language
