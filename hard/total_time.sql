-- Server Utilization Time

-- Write a query that calculates the total time that the fleet of servers was running. The output should be in units of full days.

-- Assumptions:

-- Each server might start and stop several times.
-- The total time in which the server fleet is running can be calculated as the sum of each server's uptime.


with cte as (select * ,
lead(status_time) over(order by server_id,status_time) as endt
from server_utilization
),
cte1 as(
select * ,
 round(EXTRACT(EPOCH FROM (endt - status_time)) / 3600 ,0)AS hours
from cte 
where session_status = 'start')

select round(sum(hours)/24,0) from cte1
