/*1. Creators who published a monetized & non-monetized video?
Which creators published a monetized video 5 mins or longer followed by a non-monetized video that was also 5 mins or longer? Round intermediary calculations to 2 decimals.Output the email of creators sorted the alphabetical order.

soultion :
*/
WITH video_cte AS (
    SELECT
        v.user_id,
        u.email,
        v.is_monetized,
        ROUND(v.duration_sec / 60.0, 2) AS duration_min,

        LEAD(v.is_monetized) OVER (
            PARTITION BY v.user_id
            ORDER BY v.published_at
        ) AS next_is_monetized,

        LEAD(ROUND(v.duration_sec / 60.0, 2)) OVER (
            PARTITION BY v.user_id
            ORDER BY v.published_at
        ) AS next_duration_min

    FROM youtube_videos v
    JOIN youtube_users u
        ON v.user_id = u.user_id
)

SELECT DISTINCT email
FROM video_cte
WHERE is_monetized = TRUE
  AND duration_min >= 5
  AND next_is_monetized = FALSE
  AND next_duration_min >= 5
ORDER BY email;
