--PH Employee DB Querry 
--Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Create table for retiring employees
SELECT first_name, last_name, emp_no
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Drop retirement table
Drop TABLE retirement_info;
--Recreate retirement with emp_no 
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--Check the table
SELECT*FROM retirement_info;
-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
SELECT*FROM current_emp;
-- Employee count by department number
SELECT COUNT (ce.emp_no), de.dept_no
INTO current_emp_department
FROM current_emp as ce 
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- List of retiring employees general info. 
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO retiring_emp_info
FROM employees as e 
INNER JOIN salaries as s 
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date ='9999-01-01');
-- List of managers per department
SELECT d.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager as dm
INNER JOIN departments as d 
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp as ce 
ON (dm.emp_no = ce.emp_no);
-- List of retirees by department
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d 
ON (de.dept_no = d.dept_no);
-- List of retirees of Sales department
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_dept
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments as d 
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');
-- List of retirees of Sales and Development department
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_development_dept
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments as d 
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales','Development');
-- Key question from query analysis
-- 1. What’s going on with the salaries?
-- 2. Why are there only five active managers for nine departments?
-- 3. Why are some employees appearing twice?
