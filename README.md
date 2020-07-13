# Pewlett-Hackard-Analysis
- background and goal : human resource data analysis with SQL 
- Bobby’s manager would like to know how many roles will need to be filled as the “silver tsunami” begins to make an impact. They would also like to identify retirement-ready employees who qualify to mentor the next generation of Pewlett Hackard employees.


# introduce the problem that you were using data to solve
- there are duplicates that we will need to address before sharing with management. This is because some employees have switched titles over the years so the table contain some duplicates. 


# summarize the steps that you took to solve the problem, as well as the challenges that you encountered along the way. This is an excellent spot to provide examples and descriptions of the code that you used.
-Create a new table that includes only the most recent title of each employee with partitioning
- In order to find duplicates we face two problems:

- Count the number of rows in each group.
- Find duplicate rows and theirs ids

# In your final paragraph, share the results of your analysis and discuss the data that you’ve generated. Have you identified any limitations to the analysis? What next steps would you recommend?
- 