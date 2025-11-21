# Employee Management System (SQL Project)

This project is a **complete SQL-based Employee Management System** designed using MySQL.
It covers **database creation, table design, relationships, sample queries, and data retrieval**—making it a strong portfolio project for Data Analysis, SQL development.

---

## Project Overview

The project demonstrates:

* Designing a **relational database** for employee management
* Creating multiple tables with **primary & foreign key relationships**
* Handling employee data, job departments, salaries, payroll, leave tracking, and qualifications
* Writing SQL queries to explore, join, and fetch meaningful insights

---

## Database Structure

### **Database Name**

```
employee_managmentsystem
```

### **Main Tables Created**

1. **JobDepartment**
2. **SalaryBonus**
3. **Qualification**
4. **Employee**
5. **Leaves**
6. **Payroll**

Each table handles a specific component of employee data to maintain modular and scalable design.

---

## 🛠 SQL Features Used

✔ CREATE DATABASE
✔ CREATE TABLE with constraints
✔ PRIMARY & FOREIGN KEYS
✔ INSERT statements
✔ SELECT (basic & advanced)
✔ Data analysis queries
✔ Table relationships (Joins & references)

---

## Included SQL File

The uploaded file contains:

* Full database creation
* All table structures
* Sample data insertions
* Data retrieval queries:

```sql
select * from employee;
select * from jobdepartment;
select * from leaves;
select * from payroll;
select * from qualification;
select * from salary_bonus;
```

 **File:** `/mnt/data/7efdb06a-9069-42b1-b0ea-2377715d4350.sql`

---

## Entity-Relationship (ER) Model (Conceptual)

**Employee → JobDepartment** (Many-to-One)
**Employee → Qualification** (One-to-One)
**Employee → Leaves** (One-to-Many)
**Employee → Payroll** (One-to-Many)
**JobDepartment → SalaryBonus** (One-to-Many)

---

## How to Run the Project

1. Open MySQL Workbench / XAMPP / phpMyAdmin
2. Create the database:

   ```sql
   create database employee_managmentsystem;
   use employee_managmentsystem;
   ```
3. Import the `.sql` file
4. Run queries to explore data

---

## Sample Output Queries

You can run:

```sql
show tables;
select * from employee;
select * from jobdepartment;
select * from salary_bonus;
```

---

## Project Purpose

This project showcases:

* SQL database design skills
* Real-world employee management schema
* Ability to work with multiple interconnected tables
* Practical experience with MySQL

---

##  Author

**Namburi Lakshmi Surya Prakash**
*Data Analysis with MySQL – Innomatics Research Labs (2025)*

---
