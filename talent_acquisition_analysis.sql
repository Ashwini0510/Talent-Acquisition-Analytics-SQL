-- CHALLENGE 1: Average Days to Hire by Department
SELECT department, ROUND(AVG(days_to_hire), 1) AS avg_days_to_hire
FROM applications 
WHERE application_status = 'Hired'
GROUP BY department;

-- CHALLENGE 2: Master Department & Hired Candidate Report
SELECT recruitment_budget.department, applications.candidate_name
FROM recruitment_budget
LEFT JOIN applications ON recruitment_budget.department = applications.department
WHERE applications.application_status = 'Hired' 
   OR applications.application_status IS NULL;

-- CHALLENGE 3: Recruitment Budget Status Audit
SELECT department,
       CASE 
           WHEN actual_offered_salary > max_budget_salary THEN 'Over Budget'
           WHEN actual_offered_salary = max_budget_salary THEN 'On Budget'
           ELSE 'Under Budget'
       END AS budget_status
FROM recruitment_budget;