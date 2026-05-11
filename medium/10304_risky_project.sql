-- =========================================================
-- Risky Projects
-- Difficulty: Medium
-- Platform: https://platform.stratascratch.com/coding/10304-risky-projects
-- =========================================================
-- =========================================================

WITH project_expenses AS (

    SELECT
        p.id,
        p.title,
        p.budget,

        CEILING(
            SUM(
                (
                    DATEDIFF(e.end_date, e.start_date) + 1
                ) * em.salary / 365.0
            )
        ) AS prorated_employee_expense

    FROM linkedin_projects p

    JOIN linkedin_emp_projects e
        ON p.id = e.project_id

    JOIN linkedin_employees em
        ON e.emp_id = em.id

    GROUP BY
        p.id,
        p.title,
        p.budget
)

SELECT
    title,
    budget,
    prorated_employee_expense

FROM project_expenses

WHERE prorated_employee_expense > budget;
