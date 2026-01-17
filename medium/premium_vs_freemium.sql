/*
-----------------------------------------------------------------------------
Problem: Premium vs Freemium
Platform: StrataScratch
ID: 10300
Difficulty: Medium
Updated: January 2026

Description:
Find the total number of downloads for paying and non-paying users by date. 
Include only records where non-paying customers have more downloads than 
paying customers. The output should be sorted by earliest date first and 
contain 3 columns: date, non-paying downloads, paying downloads.
-----------------------------------------------------------------------------
*/

SELECT 
    date,
    non_paying,
    paying
FROM (
    SELECT 
        c.date,
        -- Sum downloads for non-paying customers ('no')
        SUM(CASE WHEN b.paying_customer = 'no' THEN c.downloads ELSE 0 END) AS non_paying,
        -- Sum downloads for paying customers ('yes')
        SUM(CASE WHEN b.paying_customer = 'yes' THEN c.downloads ELSE 0 END) AS paying
    FROM ms_user_dimension a
    JOIN ms_acc_dimension b ON a.acc_id = b.acc_id 
    JOIN ms_download_facts c ON a.user_id = c.user_id
    GROUP BY c.date
) sub_query
WHERE non_paying > paying
ORDER BY date ASC;
