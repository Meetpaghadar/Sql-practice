/*
Problem: Vehicle Gear Usage

Description:
A company tracks gear changes for delivery vehicles. Each record contains:
- car_id
- timestamp_epoch (Unix time in seconds)
- gear ('P', 'D', 'R')

Task:
Calculate the total number of hours all vehicles spent in each gear.

Rules:
1. Duration of a gear = difference between current timestamp and previous timestamp
2. For the final gear record of each vehicle (no next event), assume duration = 2 hours (7200 seconds)
3. Return total hours per gear

Author: [Your Name]
Date: April 2026
*/

WITH base AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY car_id 
            ORDER BY timestamp_epoch
        ) AS rnk,

        LAG(timestamp_epoch) OVER (
            PARTITION BY car_id 
            ORDER BY timestamp_epoch
        ) AS prev_time,

        LAG(gear) OVER (
            PARTITION BY car_id 
            ORDER BY timestamp_epoch
        ) AS prev_gear

    FROM vehicle_telemetry
),

maxx AS (
    SELECT 
        *,
        MAX(rnk) OVER (PARTITION BY car_id) AS max_rn
    FROM base
),

final AS (
    SELECT 
        car_id,
        timestamp_epoch,
        gear,

        -- Parking duration
        CASE 
            WHEN prev_gear = 'P' THEN timestamp_epoch - prev_time
            WHEN rnk = max_rn AND gear = 'P' THEN 7200
        END AS parking_time,

        -- Reverse duration
        CASE 
            WHEN prev_gear = 'R' THEN timestamp_epoch - prev_time
            WHEN rnk = max_rn AND gear = 'R' THEN 7200
        END AS reverse_time,

        -- Driving duration
        CASE 
            WHEN prev_gear = 'D' THEN timestamp_epoch - prev_time
            WHEN rnk = max_rn AND gear = 'D' THEN 7200
        END AS driving_time

    FROM maxx
)

-- Final output: total hours per gear
SELECT 'P' AS gear, SUM(parking_time)/3600.0 AS total_hours
FROM final

UNION ALL

SELECT 'R', SUM(reverse_time)/3600.0
FROM final

UNION ALL

SELECT 'D', SUM(driving_time)/3600.0
FROM final;
