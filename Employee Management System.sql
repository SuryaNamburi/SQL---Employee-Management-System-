create database employee_managmentsystem;
use employee_managmentsystem;

show databases;
-- Table 1: Job Department
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);
-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
    REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);
show tables;
select * from employee;
select * from leaves;
select * from jobdepartment;
select * from payroll;
select * from qualification;
select * from Salary_Bonus;

-- 1. EMPLOYEE INSIGHTS
-- 1.1How many unique employees are currently in the system?
select distinct count(FirstName) as unique_employees from employee;

-- 1.2.Which departments have the highest number of employees?
SELECT JobDept, COUNT(*) AS total_employees
FROM jobdepartment
GROUP BY JobDept
ORDER BY total_employees DESC
LIMIT 2;

-- 1.3.What is the average salary per department?
select JobDept, avg(amount) as avg_salary
from jobdepartment as jd
join salary_bonus as sb
on jd.JobID = sb.JobID
group by JobDept;

-- 1.4.Who are the top 5 highest-paid employees?
select FirstName,LastName,Amount as highest_paid  
from employee as e
join salary_bonus as sb
on e.jobid = sb.jobid
order by highest_paid Desc
limit 5;

-- 1.5.What is the total salary expenditure across the company?
select sum(amount)  as total_salary_expenditure
from salary_bonus;

-- 2. JOB ROLE AND DEPARTMENT ANALYSIS
-- 2.1.How many different job roles exist in each department?
SELECT JobDept, COUNT(Name) AS count_of_jobroles_in_each_department
FROM jobdepartment
GROUP BY JobDept
order by count_of_jobroles_in_each_department desc;

-- 2.2.What is the average salary range per department?
SELECT 
  JobDept,
  SalaryRange,
  (
    (CAST(SUBSTRING_INDEX(REPLACE(SalaryRange, '$', ''), ' - ', 1) AS UNSIGNED) +
     CAST(SUBSTRING_INDEX(REPLACE(SalaryRange, '$', ''), ' - ', -1) AS UNSIGNED)) / 2
  ) AS Avg_Salary
FROM jobdepartment;

-- 2.3.Which job roles offer the highest salary?
SELECT Name, Amount AS highest_salary
FROM jobdepartment as jd
JOIN salary_bonus as sb
  ON sb.JobID = jd.JobID
order by highest_salary desc;

-- 2.4.Which departments have the highest total salary allocation?
select  JobDept,(amount + annual + bonus) as highest_total_salary 
from salary_bonus as sb
join jobdepartment as jd
on sb.JobID = jd.JobID
order by highest_total_salary desc
limit 5;

-- 3. QUALIFICATION AND SKILLS ANALYSIS
-- 3.1.How many employees have at least one qualification listed?
SELECT COUNT(DISTINCT e.EmpID) AS employees_with_qualification
FROM employee e
JOIN qualification q
  ON e.EmpID = q.EmpID
WHERE q.Requirements IS NOT NULL;

-- 3.2.Which positions require the most qualifications?
SELECT Position, COUNT(Requirements) AS total_qualifications
FROM qualification
WHERE Requirements IS NOT NULL
  AND TRIM(Requirements) <> ''
GROUP BY Position
ORDER BY total_qualifications DESC;

-- 3.3.Which employees have the highest number of qualifications?
select e.FirstName, e.LastName, count(q.requirements) as highest_qualification
from qualification as q
join employee as e
on e.EmpID = q.EmpID
where q.Requirements is not null
group by e.FirstName, e.LastName
order by highest_qualification desc;

-- 4. LEAVE AND ABSENCE PATTERNS
-- 4.1.Which year had the most employees taking leaves?
SELECT YEAR(Date) AS leave_year, COUNT(*) AS total_leaves
FROM leaves
GROUP BY YEAR(Date)
ORDER BY leave_year;

-- 4.2.What is the average number of leave days taken by its employees per department?
SELECT 
    j.JobDept,
    AVG(emp_leaves.total_leaves) AS avg_leave_days_per_dept
FROM (
    SELECT 
        e.EmpID,
        COUNT(l.Date) AS total_leaves
    FROM leaves l
    JOIN employee e ON e.EmpID = l.EmpID
    GROUP BY e.EmpID
) AS emp_leaves
JOIN employee e ON emp_leaves.EmpID = e.EmpID
JOIN jobdepartment j ON e.JobID = j.JobID
GROUP BY j.JobDept;

-- 4.3.Which employees have taken the most leaves?
select e.empid, e.FirstName, count(l.date) as most_leaves
from leaves as l
join employee as e
on e.EmpID = l.EmpID
group by e.empid, e.FirstName;

-- 5. PAYROLL AND COMPENSATION ANALYSIS
-- 5.1.What is the total monthly payroll processed?
select report, sum(TotalAmount) as total_monthly_payroll
from payroll
group by report;

-- 5.2.What is the average bonus given per department?
select  jd.JobDept, avg(sb.Bonus) as Avg_Bonus_Per_Department 
from jobdepartment as jd
join salary_bonus as sb
on sb.JobID = jd.JobID
group by JobDept
order by Avg_Bonus_Per_Department desc;

-- 5.3.Which department receives the highest total bonuses?
select  jd.JobDept, sum(sb.Bonus) as max_Bonus_Per_Department 
from jobdepartment as jd
join salary_bonus as sb
on sb.JobID = jd.JobID
group by JobDept
order by max_Bonus_Per_Department desc
limit 1;

-- 5.4 What is the average value of total_amount after considering leave deductions?





show tables;
select * from employee;
select * from jobdepartment;
select * from leaves;
select * from payroll;
select * from qualification;
select * from salary_bonus;


