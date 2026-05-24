# Case Study: Talent Acquisition Pipeline & Budget Audit (HR Analytics)

## 📌 Business Overview & Context
In fast-growing organizations, recruitment efficiency and budget adherence are critical metrics for human resources operations. Delays in the hiring pipeline cause top talent to drop out, while unmonitored salary offers lead to departmental budget deficits. 

As the **HR Data Analyst**, my objective was to perform a comprehensive database audit of our recruitment pipeline. I aimed to identify structural bottlenecks in departmental hiring speeds, build a master tracking ledger for cross-departmental hiring, and deploy conditional logic to instantly flag budget overruns for corporate leadership.

## 🗃️ Database Architecture & Schemas
The analysis evaluates operational HR data up to May 2026 across two main tables:

### 1. `applications` (Candidate Pipeline Tracker)
| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `candidate_id` | INT (PK) | Unique identifier for the applicant |
| `candidate_name` | VARCHAR | Full name of the candidate |
| `department` | VARCHAR | Targeted business department ('Engineering', 'Sales', etc.) |
| `recruitment_source` | VARCHAR | Origin channel of application ('LinkedIn', 'Referral', etc.) |
| `application_status` | VARCHAR | Pipeline status ('Hired', 'Rejected', 'In Progress') |
| `days_to_hire` | INT | Calendar days from initial application to offer acceptance |

### 2. `recruitment_budget` (Compensation & Ledger Caps)
| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `department` | VARCHAR (PK) | Corporate department name |
| `max_budget_salary` | INT | Maximum approved annual salary cap for the department |
| `actual_offered_salary` | INT | Total compensation offered to hired candidates |

---

## 🕵️‍♂️ Key Analytics Challenges & SQL Approaches

### Challenge 1: Diagnosing Pipeline Bottlenecks
* **Business Objective:** Validate organizational complaints regarding hiring delays and isolate slow-moving department pipelines.
* **SQL Strategy:** Combined `AVG` and `ROUND` functions, grouped by department, to evaluate true operational speed.

```sql
SELECT department, ROUND(AVG(days_to_hire), 1) AS avg_days_to_hire
FROM applications 
WHERE application_status = 'Hired'
GROUP BY department;
Business Impact: Revealed that the Engineering pipeline lags significantly at 38.3 days, whereas Sales completes hires in a highly efficient 12 days. This provides concrete evidence that engineering needs optimized technical evaluation stages.

Challenge 2: Master Department Ledger (Cross-Functional Visibility)
Business Objective: Provide leadership with a single view of all company departments alongside their active hires, ensuring teams with zero hires are still tracked.

SQL Strategy: Implemented a LEFT JOIN prioritizing the budget table to prevent empty departments from being filtered out.

SQL
SELECT recruitment_budget.department, applications.candidate_name
FROM recruitment_budget
LEFT JOIN applications ON recruitment_budget.department = applications.department
WHERE applications.application_status = 'Hired' 
   OR applications.application_status IS NULL;
Business Impact: Successfully included the Marketing department (NULL hires) in executive tracking, highlighting active budget allocations that have yet to onboard talent.

Challenge 3: Automated Salary Budget Audit
Business Objective: Instantly categorize financial health across departments without requiring manual spreadsheet formulas.

SQL Strategy: Deployed conditional logical expressions using CASE WHEN to evaluate offer letters against financial caps.

SQL
SELECT department,
       CASE 
           WHEN actual_offered_salary > max_budget_salary THEN 'Over Budget'
           WHEN actual_offered_salary = max_budget_salary THEN 'On Budget'
           ELSE 'Under Budget'
       END AS budget_status
FROM recruitment_budget;
Business Impact: Flagged Engineering as 'Over Budget' ($1.65M actual vs $1.5M max cap), providing Total Rewards leaders with an immediate focal point for compensation adjustments.
