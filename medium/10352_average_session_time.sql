/* -----------------------------------------------------------------------
PROBLEM: Users By Average Session Time
SOURCE: StrataScratch
ID: 10352
DIFFICULTY: Medium
-----------------------------------------------------------------------

DESCRIPTION:
Calculate each user's average session time, where a session is defined 
as the time difference between a page_load and a page_exit. 

ASSUMPTIONS:
1. Each user has only one session per day.
2. If there are multiple page_load or page_exit events on the same day:
   - Use only the latest page_load.
   - Use the earliest page_exit.
3. Only consider sessions where the page_load occurs before the page_exit.

OUTPUT: 
- user_id
- average session time
*/

-- SOLUTION START --

with cte as (
select *
from (
select *,row_number() over(partition by user_id,date(timestamp),action order by timestamp desc) as rnk1,
    row_number() over(partition by user_id,date(timestamp),action order by timestamp asc) as rnk2
from facebook_web_log
where action="page_load" or action="page_exit"
)t
),

page_loads as(
select * from cte
where rnk1=1 and action="page_load"
),

page_exits as(
select * from cte
where rnk2=1 and action="page_exit"
),

final as (
select pl.user_id,pl.timestamp as plt,pe.timestamp as pet,timediff(pe.timestamp,pl.timestamp) as td
from page_loads pl
join page_exits pe
on pl.user_id=pe.user_id and date(pl.timestamp)=date(pe.timestamp)
)

SELECT 
    user_id,
    AVG(TIME_TO_SEC(td)) AS avg_session_duration
FROM final
GROUP BY user_id;
