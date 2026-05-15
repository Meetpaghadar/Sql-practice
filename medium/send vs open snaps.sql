-- Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

-- Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

-- Notes:

-- Calculate the following percentages:
-- time spent sending / (Time spent sending + Time spent opening)
-- Time spent opening / (Time spent sending + Time spent opening)
-- To avoid integer division in percentages, multiply by 100.0 and not 100.

-- ====================================================================================================================================
-- solution -> 

with cte as (select a.activity_type,a.time_spent,b.age_bucket
from activities a 
join age_breakdown b on a.user_id = b.user_id
),
tt as (
select age_bucket,
sum(time_spent) filter(where activity_type= 'open') as opentime,
sum(time_spent) filter(where activity_type= 'send') as sendtime
from cte 
group by age_bucket)

select age_bucket,
round((opentime/(opentime + sendtime))*100,2) as open_perc,
round((sendtime/(opentime+sendtime)) * 100,2) as send_perc
from tt
