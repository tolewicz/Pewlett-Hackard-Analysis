# Pewlett-Hackard-Analysis
Creating and managing Data Basis

## Project Overview
Create data basis that will help to image the number of people who will retire from PH and adjust the rester for mentor training

## Resources
-	Imput excell sheets with emplyees data
-	Software: SQL, pgAdmin4, QuickDatabaseDiagrams


# Mentor Program Challenge

In the PH there are 300,000 employees and 33,118 of them (~10%) will retire. For that PH had to accomodate a trasition program where non retired, experienced employees woudl train new hires. To do that we need to know how many employees retired, how many employees are experienced i.e. close to retire but still within organization. 

The number of the employees that are about to retire was determined using by joining following tables: employees and dept_emp, and filtered by age and date of hire.

Figure.1

<p align="center">
<img src="https://github.com/tolewicz/Pewlett-Hackard-Analysis/blob/master/Figures/ERDTableB.PNG" width="450">
</p>

The code for determining the number of employees retirening is as follows: 

SELECT e.emp_no, e.first_name, e.last_name, de.to_date
--INTO retirement1
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31') and de.to_date = ('9999-01-01')

The above code joins employee and dept_emp tables abd filters out all the employees that are not about to retire, leaving the table with retiring employees only. 

Figure 2

<img src="https://github.com/tolewicz/Pewlett-Hackard-Analysis/blob/master/Figures/ERDTableA.PNG" width="450">

The filter used for extracting retired employees is:

**WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31') and de.to_date = ('9999-01-01')

The part one of the challenge requested to provide Employee number, First and last name, Title, from_date, to_date, for all the PH employees across the years. The  This caused duplications of some of the positions as the employees changed their function over the years.

Fig3.

<img src="https://github.com/tolewicz/Pewlett-Hackard-Analysis/blob/master/Figures/DoubleTitle.PNG" width="450">

Thus, the table was filtered to the most recent position, and provided the complete roster of employees in the organization with their most recent job function and w/o duplications.

fig.4

Based on that we could also determine the number or employees per job function. That will gives us the highlight of high job roles that can be impacted the most by loosing personnel e.g. management, only 9 employees.

Fig.5

The last part of the program filtered the employees who are close to retire, but are still within organization. Those employees were born in 1965 and were hired between 1985 and 1988. Unfortunately the number of those employees is 550.

There are following key queries: 

SELECT * FROM retiremetn2_cln - list of employees that are retire
SELECT * FROM title_salaries_cln - list of all employees with current job function and salary
SELECT * FROM replacement_cln - list of employees ready to mentor


