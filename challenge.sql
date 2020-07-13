-- Challemge 
--Number of Retiring Employees by title 
SELECT e.emp_no,
	e.last_name,
	e.first_name,
	ti.title,
	ti.from_date,
	ti.to_date,
	s.salary
INTO retirees_title_all
FROM employees as e
INNER JOIN salaries as s 
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Partition the data to show only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	salary
INTO retirees_title_unique
FROM
 (SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	salary, 
  ROW_NUMBER() OVER (PARTITION BY (emp_no)
  ORDER BY to_date DESC) as rn
 FROM retirees_title_all) tmp
WHERE tmp.rn = 1
ORDER BY emp_no;