/*
-----------------------------------------------------------------------------
Problem: Ranking Most Active Guests
Platform: StrataScratch
ID: 10159
Difficulty: Medium
Updated: January 2026

Description:
Identify the most engaged guests by ranking them according to their overall 
messaging activity. The most active guest (most messages exchanged) should 
have the highest rank (Rank 1). 

Requirements:
1. If two or more guests have the same number of messages, they should have 
   the same rank.
2. The ranking shouldn't skip any numbers (use DENSE_RANK).
3. Output columns: Rank, Guest Identifier, and Total Messages.
4. Order from most to least active.
-----------------------------------------------------------------------------
*/

SELECT 
    DENSE_RANK() OVER(ORDER BY SUM(n_messages) DESC) AS ranking,
    id_guest,
    SUM(n_messages) AS sum_messages
FROM airbnb_contacts
GROUP BY id_guest
ORDER BY sum_messages DESC;
