-- Employees whose employer was google right after microsoft

with cte as (
select *
,lead(employer) over(partition by user_id order by start_date) next_comp
from employment_history )
select * from cte where employer='Microsoft'
and next_comp='Google
