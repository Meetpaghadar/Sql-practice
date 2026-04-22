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
*/
/*  not so good solution i thought i have to maintain user_id and sender_id*/--============================================================
select fs.date,((count (case when fr.action = 'accepted' then 1  end))*1.0/
(count(case when fs.action = 'sent' and fr.action = 'sent' then 1  end))) as percentage_acceptance
from
fb_friend_requests fs
full join fb_friend_requests fr
on fs.user_id_sender = fr.user_id_sender and 
fs.user_id_receiver = fr.user_id_receiver
where fs.action = 'sent' 
group by fs.date

/*good one*/--============================================================================================================================
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
/* Better and Compact solution */--===================================================================================================================
SELECT 
    date,
    
    COUNT(CASE WHEN action = 'accepted' THEN 1 END) * 1.0
    / COUNT(CASE WHEN action = 'sent' THEN 1 END) AS acceptance_rate

FROM fb_friend_requests

GROUP BY date
HAVING COUNT(CASE WHEN action = 'sent' THEN 1 END) > 0;
