# Overview 
## Background and goal of Pewlett-Hackard(PH)-Analysis
- Pewlett-Hackard is a virtual tech company who is facing “silver tsunami” in near future cause of baby boomer's retirements. The HR team of PH would like to know how many roles will need to be filled as the “silver tsunami” begins to make an impact. They would also like to identify retirement-ready employees who qualify to mentor the next generation of Pewlett Hackard employees.
## Techniques used 
- PostgreSQL with pgAdmin4
- VSCode
- ERD created with quickdatabasediagrams.com


# Analysis 
## Number of Retiring Employees by Title
- For this analysis, we created a table containing the number of employees who are about to retire (those born 1952-1955), grouped by job title, with following information; <br/>
Employee number, first and last name, tItle, from_date, salary <br/>
- To get all the columns  the number of roles need to be filled, we need to reference 3 tables - Employee, Titles, Salaries. ERD shows the relationsip between original database for 6 tables. <br/>

![ERD](https://github.com/Juuune/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png)

`SELECT e.emp_no,`
`	    e.last_name, `
`	    e.first_name, `
`	    ti.title, `
`	    ti.from_date, `
`	    ti.to_date, `
`	    s.salary `
`INTO retirees_title_all `
`FROM employees as e `
`INNER JOIN salaries as s `
`ON (e.emp_no = s.emp_no) `
`INNER JOIN titles as ti `
`ON (e.emp_no = ti.emp_no)`
`WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') `
`ORDER BY e.emp_no; `

- With new table we created, there are duplicates that we will need to address before sharing with management. <br/>
This is because some employees have switched titles over the years so the table contain some duplicates. 

- Create a new table that includes only the most recent title of each employee with partitioning. <br/>
In order to find duplicates we face two problems: <br/>
 1) Count the number of rows in each group. <br/>
 2) Find duplicate rows and theirs ids <br/>

- To solve those problems we changed sql querries as below; <br/>
`SELECT emp_no, `
`	first_name, `
`	last_name, `
`	title, `
`	from_date, `
`	salary`
`INTO current_retirees_title `
`FROM`
`  (SELECT emp_no,`
`	      first_name, `
`	      last_name, `
`	      title, `
`	      from_date, `
`	      salary, `
` ROW_NUMBER() OVER (PARTITION BY (emp_no) `
` ORDER BY to_date DESC) as rn `
`FROM retirees_title_all) tmp `
`WHERE tmp.rn = 1 `
`ORDER BY emp_no; `
 
![current_retirees_title example](https://github.com/Juuune/Pewlett-Hackard-Analysis/blob/master/Challenge/current_retirees_title_example.PNG) <br/>

- After adjust our code new table current_retirees_title will contain all the information we need without duplication. <br/>
Now we can create another table to calculate numer of retiress by title by selecting columns from this table and count(emp_no) function. 
` SELECT title,`
`	     count(emp_no) `
` INTO number_employees_title `
` FROM titles `
` WHERE (to_date='9999-01-01') `
` GROUP BY title `
` ORDER BY title DESC; `
 
![Number of employees by Title](https://github.com/Juuune/Pewlett-Hackard-Analysis/blob/master/Challenge/num_employees_title.PNG)
![Number of retirees by Title](https://github.com/Juuune/Pewlett-Hackard-Analysis/blob/master/Challenge/num_retirees_tilte.PNG)

## Mentorship Eligibility
- To be eligible to participate in the mentorship program, employees will need to have a date of birth that falls between January 1, 1965 and December 31, 1965. 
Mentorship eligibility table would include following information ; employee number, first and last name, title, from date and to date
- According to ERD we've created earlier, we need to reference 2 table with inner join. If we use code below to select columns from 2 table and inner join then the result table would have duplication. 
`SELECT e.emp_no,`
`       e.first_name, `
`	   e.last_name, `
`	   ti.title, `
`	   ti.from_date, `
`	   ti.to_date `
` INTO mentorship_eligibility `
` FROM employees as e `
` INNER JOIN titles as ti `
` ON e.emp_no = ti.emp_no `
` WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') `
` ORDER BY e.emp_no ; `

- To solve this problem, we can use 'WHERE' fuction to choose employees whose to-date is set to 9999-01-01. Then the result would contain employees whose title is current status. <br/>
 `WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') `
 ` AND (ti.to_date ='9999-01-01')`
![Mentorship Eligibility example](https://github.com/Juuune/Pewlett-Hackard-Analysis/blob/master/Challenge/mentorship_example.PNG)

# Summary and Conclusion 
- Summary of the results:  <br/>
1) Total number of employees : 300024  <br/>
2) Total number of individuals retiring :90398  <br/>
3) Total number of individuals available for mentorship role : 1549

- PH is about to loose 1/3 of its employees by silver tsunami and there's only 1549 of current employees is eligibable for mentorship role. Especially engineer and assistant engineer would loose half of its workforce. 
- In order to conduct a detailed plan we need to calculate how many roles of each department is retiring. (using 'current_retirees_title' and 'department')
- We can also caculate the sum of current salaries of retirees to mesure the impact on HR expense.   

![ERD](https://github.com/Juuune/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png)

