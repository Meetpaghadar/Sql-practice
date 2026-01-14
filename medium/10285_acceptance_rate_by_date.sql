/* -----------------------------------------------------------------------
PROBLEM: Acceptance Rate By Date
SOURCE: StrataScratch
ID: 10285
DIFFICULTY: Medium
-----------------------------------------------------------------------

DESCRIPTION:
Calculate the friend acceptance rate for each date when friend requests were sent. 
A request is sent if action = sent and accepted if action = accepted. 
If a request is not accepted, there is no record of it being accepted in the table.

The output will only include dates where requests were sent and at least one of 
them was accepted (acceptance can occur on any date after the request is sent).

OUTPUT:
- date
- acceptance_rate
*/

-- SOLUTION START --

WITH tmp AS (
    SELECT 
        user_id_sender, 
        user_id_receiver, 
        MIN(date) AS date,
        SUM(CASE WHEN action = 'accepted' THEN 1 ELSE 0 END) AS accepted_cnt,
        SUM(CASE WHEN action = 'sent' THEN 1 ELSE 0 END) AS sent_cnt
    FROM fb_friend_requests
    GROUP BY 1, 2
)

SELECT 
    date, 
    SUM(accepted_cnt) / SUM(sent_cnt) AS acceptance_rate
FROM tmp
GROUP BY date;
