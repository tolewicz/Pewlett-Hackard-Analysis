-- Creating base tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name) 
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
	);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
	);
	

--Search for retirement eglibilitys METHOD 1-----------
SELECT e.emp_no, e.first_name, e.last_name, de.to_date
--INTO retirement1
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31') and de.to_date = ('9999-01-01');

--Search for retirement eglibilitys METHOD 2 with titles-----------

SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date
--INTO retirement2
FROM employees as e
LEFT JOIN titles as ti
	ON (ti.emp_no = e.emp_no)
LEFT JOIN dept_emp as de
	ON (de.emp_no = e.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') -- filtering goes second
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31') AND (de.to_date = '9999-01-01');

--we filter the resoults to get rid of duplication due to title change over the years
SELECT emp_no, first_name, last_name, title, from_date
INTO retirement2_cln
FROM (SELECT emp_no, first_name, last_name, title, from_date,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no,first_name, last_name) ORDER BY emp_no DESC) rn
   FROM retirement2
  ) tmp WHERE rn = 1;

--Method 1 and 2 give the same result

------------------------HW #1 join tables---------------------------
SELECT e.emp_no, e.first_name, e.last_name, s.salary, ti.title, ti.from_date
INTO title_salaries
FROM employees as e
INNER JOIN titles as ti
	ON (ti.emp_no = e.emp_no)
INNER JOIN salaries as s
	ON (s.emp_no = e.emp_no);

SELECT * FROM title_salaries ORDER BY emp_no --it has duplicates due to change position of employees


-------------------HW table #2 cleanned employee roster and title count------------------

--1. Removing duplicates, selecting most recent title
SELECT emp_no, first_name, last_name, title, from_date, salary 
--INTO title_salaries_cln
FROM (SELECT emp_no, first_name, last_name, title, from_date, salary,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no, first_name, last_name) ORDER BY from_date DESC) rn
   FROM title_salaries
  ) tmp WHERE rn = 1;

--2. Counting how many titles was used
--Creating empty table
CREATE TABLE title_count (title_count int,Title varchar(255))

--inserting groupby values of number of titles
INSERT INTO title_count
SELECT COUNT (ts.emp_no), ts.title FROM title_salaries_cln as ts
GROUP BY ts.title 
; 
 
SELECT * FROM title_count

----------------HW table #3 Replacement_mentor_roster--------------
-- filtering out avaliable candidates for mentoring
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, s.salary
INTO replacement
FROM employees as e
LEFT JOIN titles as ti
	ON (ti.emp_no = e.emp_no)
	LEFT JOIN salaries as s
	ON (s.emp_no = e.emp_no)
	LEFT JOIN dept_emp as de
	ON (de.emp_no = e.emp_no)
	WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') -- filtering by age 
	AND (de.to_date <> '9999-01-01'); --filering by active employees

SELECT emp_no, first_name, last_name, title, from_date, salary 
INTO replacement_cln
FROM (SELECT emp_no, first_name, last_name, title, from_date, salary,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no,first_name, last_name) ORDER BY from_date DESC) rn
   FROM replacement
  ) tmp WHERE rn = 1;

------------Query------------

SELECT * FROM departments
SELECT * FROM employees
SELECT * FROM dept_emp
SELECT * FROM dept_manager
SELECT * FROM salaries
SELECT * FROM titles

SELECT * FROM retirement1
SELECT * FROM retirement2
SELECT * FROM retiremetn2_cln

SELECT * FROM title_salaries
SELECT * FROM title_salaries_cln
SELECT * FROM title_count

SELECT * FROM replacement
SELECT * FROM replacement_cln






