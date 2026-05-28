-- Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

-- Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

-- Definition:

-- Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.

with cte as (select measurement_id,measurement_value,Date(measurement_time),measurement_time,
row_number()over(partition by Date(measurement_time) order by  measurement_time) as rnk
from measurements
)
select 
date as measurement_day ,
sum(case when rnk%2 = 0 then measurement_value else 0 end ) as even_sum,
sum(case when rnk%2 = 1 then measurement_value else 0 end ) as odd_sum
from cte
GROUP by date
