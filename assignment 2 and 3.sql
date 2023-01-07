/*
employee(employee-name, street, city)
works(employee-name, company-name, salary)
company(company-name, city)
manages (employee-name, manager-name)
*/
# For Q.2,3
#to create databASe 
CREATE DATABASE db_employees;
#to create a table
USE db_employees;
CREATE TABLE employee (
  employee_name VARCHAR(255) not null primary key, 
  street VARCHAR(255), 
  city VARCHAR(255)
);
CREATE TABLE company (
  company_name varchar(255) not null primary key, 
  city VARCHAR(255)
);
CREATE TABLE works (
  employee_name VARCHAR(255) not null primary key, 
  company_name varchar(255), 
  salary INT
);
CREATE TABLE manages (
  employee_name VARCHAR(255) not null primary key, 
  manager_name varchar(255)
);
#INSERT INTO tables 
#INSERT INTO the employee table
select * from employee;
INSERT INTO employee(employee_name, street, city) 
VALUES 
  ("mishan", "ab12", "chitwan"), 
  ("cook", "43ba", "hetauda"), 
  ("bikrant", "43ba", "hetauda"), 
  ("ayush", "12ab", "KTM"), 
  ("elon", "34ab", "KTM"), 
  ("prabin", "11aa", "bhaktapur"), 
  ("bishal", "25bd", "dhading"), 
  ("nikhil", "sd45", "KTM"), 
  ("samman", "gt78", "KTM"), 
  ("jones", "55abneu", "NY");
#INSERT INTO the company table
INSERT INTO company(company_name, city) 
VALUES 
  ("small bank corporation", "dhading"), 
  ("first bank corporation", "hetauda"), 
  ("apple", "KTM"), 
  ("tesla", "chitwan"),
  ("testcompany", "dhading");
#INSERT INTO the work table
INSERT INTO works(
  employee_name, company_name, salary
) 
VALUES 
  ("bishal", "small bank corporation", 1000), 
  ("nikhil", "small bank corporation", 12000), 
  ("samman", "small bank corporation", 2000), 
  ("elon", "tesla", 100000), 
  ("cook", "apple", 200000), 
  ("mishan", "tesla", 10000), 
  ("ayush", "first bank corporation", 1000), 
  ("bikrant", "apple", 100), 
  ("prabin", "first bank corporation", 50000);
#INSERT INTO the manages table
INSERT INTO manages(employee_name, manager_name) 
VALUES 
  ("bishal", "nikhil"), 
  ("samman", "nikhil"), 
  ("mishan", "elon"), 
  ("bikrant", "cook"), 
  ("ayush", "prabin");
/* Q.2CONsider the employee databASe of Figure 5, WHERE the primary keys are underlINed. Give
an expressiON IN SQL for each of the followINg queries:
*/
-- Q.2.a find the names of all employees who work for first bank corporation.
SELECT 
  employee_name 
FROM 
  works 
WHERE 
  company_name = "first bank corporation";
-- Q.2.b  find the names AND cities of residence of all employees who work for first bank corporation.
#using JOIN 2b
SELECT 
  employee.employee_name, 
  employee.city 
FROM 
  works 
  INNER JOIN employee ON works.employee_name = employee.employee_name 
WHERE 
  works.company_name = "first bank corporation";
#Q2.busing subquery 
SELECT 
  employee_name, 
  city 
FROM 
  employee 
WHERE 
  employee_name IN (
    SELECT 
      employee_name 
    FROM 
      works 
    WHERE 
      company_name = "first bank corporation"
  );
#Q.2.c find the names, street addresses, AND cities of residence of all employees who work for first bank corporation AND earn more than $10,000.
#Q.2.c using JOIN 
SELECT 
  employee.employee_name, 
  employee.city, 
  employee.street 
FROM 
  employee 
  INNER JOIN works ON works.employee_name = employee.employee_name 
WHERE 
  (works.company_name = "first bank corporation")&(works.salary > 10000);
#Q.2.c using subquery
SELECT 
  employee_name, 
  city, 
  street 
FROM 
  employee 
WHERE 
  employee_name IN (
    SELECT 
      employee_name 
    FROM 
      works 
    WHERE 
      (company_name = "first bank corporation") & (works.salary > 10000)
  );
-- Q.2.d find all employees IN the databASe who live IN the same cities AS the companies for which they work.                        
#Q.2.d using JOIN
SELECT 
  employee.employee_name 
FROM 
  employee 
  INNER JOIN works ON employee.employee_name = works.employee_name 
  INNER JOIN company ON works.company_name = company.company_name 
WHERE 
  employee.city = company.city;
#2.d using subquery
SELECT 
  e.employee_name 
FROM 
  employee e 
WHERE 
  e.city = (
    SELECT 
      c.city 
    FROM 
      company c 
    WHERE 
      EXISTS (
        SELECT 
          w.employee_name 
        FROM 
          works w 
        WHERE 
          c.company_name = w.company_name 
          AND e.employee_name = w.employee_name
      )
  );
-- Q.2.e find all employees IN the databASe who live IN the same cities AND ON the same streets AS do their managers.
#2.e using JOIN
SELECT 
  m.employee_name 
FROM 
  employee e1, 
  employee e2 
  INNER JOIN manages m ON (
    (
      m.employee_name = e2.employee_name
    )
  ) 
WHERE 
  (
    e1.employee_name <> e2.employee_name
  ) 
  AND (e1.city = e2.city) 
  AND (e1.street = e2.street);
#2.e using subquery
SELECT 
  e1.employee_name 
FROM 
  employee e1 
WHERE 
  e1.employee_name IN (
    SELECT 
      m.employee_name 
    FROM 
      manages m 
    WHERE 
      EXISTS (
        SELECT 
          e2.employee_name 
        FROM 
          employee e2 
        WHERE 
          (
            e1.employee_name <> e2.employee_name
          ) 
          AND (e1.city = e2.city) 
          AND (e1.street = e2.street)
      )
  );
-- Q.2.f  find all employees IN the databASe who do not work for first bank corporation.
SELECT 
  w.employee_name 
FROM 
  works w 
WHERE 
  w.company_name != "first bank corporation";
-- 2.g find all employees IN the databASe who earn more than each employee of Small Bank corporation.
#displayINg greater than each employee?????????
# ASsumINg the questiON is ASkINg to display all employees IN databASe with salary greater tham small bank corporation max salary
SELECT 
  * 
FROM 
  works w1 
WHERE 
  w1.salary >(
    SELECT 
      max(w2.salary) 
    FROM 
      works w2 
    WHERE 
      w2.company_name = "small bank corporation"
  );
-- Q.2.h ASsume that the companies may be located IN several cities. find all companies located IN every city IN which Small Bank corporation is located.
#2.h using JOIN
SELECT 
  c1.company_name 
FROM 
  company c1 
  INNER JOIN company c2 ON c1.city = c2.city 
WHERE 
  c2.company_name = "small bank corporation";
#2.h using sub-query
SELECT 
  company_name 
FROM 
  company c 
WHERE 
  city IN (
    SELECT 
      city 
    WHERE 
      company_name = "small bank corporation"
  );
-- Q.2.i find all employees who earn more than the average salary of all employees of their company.
#2.i using JOIN
#2.i using subquery
SELECT 
  employee_name 
FROM 
  works w1 
WHERE 
  w1.salary > (
    SELECT 
      tbl_avg.AVG_sal 
    FROM 
      (
        SELECT 
          company_name, 
          AVG(salary) AS AVG_sal 
        FROM 
          works 
        GROUP BY 
          company_name
      ) AS tbl_avg
    WHERE 
      tbl_avg.company_name = w1.company_name
  );
-- Q.2.j find the company that hAS the most employees.
#2.j using JOIN
#2.j using subquery 
SELECT 
  company_name 
FROM 
  (
    SELECT 
      company_name, 
      count(employee_name) AS no_of_employees 
    FROM 
      works 
    GROUP BY 
      company_name
  ) AS tbl_employee_counter 
ORDER BY 
  no_of_employees desc 
LIMIT 
  1;
-- Q.2.k find the company that hAS the smallest payroll.
#2.k using JOIN
#2.k using subquery
SELECT 
  company_name 
FROM 
  (
    SELECT 
      company_name, 
      sum(salary) AS payroll 
    FROM 
      works 
    GROUP BY 
      company_name
  ) AS tbl_payroll 
ORDER BY 
  payroll ASC
LIMIT 
  1;
-- Q.2.l Find those companies whose employees earn a higher salary, on average, than the average salary at first bank corporation.
#2.l using JOIN
#2.l using subquery
SELECT 
  company_name 
FROM 
  (
    SELECT 
      company_name, 
      AVG(salary) AS AVG_salary 
    FROM 
      works w 
    GROUP BY 
      company_name
  ) AS tbl_AVG_salary 
WHERE 
  AVG_salary > (
    SELECT 
      AVG(salary) 
    FROM 
      works 
    WHERE 
      company_name = "first bank corporation"
  );
# Q.3 CONsider the relatiONal databASe of Figure 5. Give an expressiON IN SQL for each of the followINg queries:
#Q3.a  Modify the databASe so that JONes now lives IN Newtown
update 
  employee 
set 
  city = "Newtown" 
WHERE 
  employee_name = "jONes";
-- Q.3.b Give all employees of first bank corporation a 10 percent raise.
#run this code to disable safe update
SET SQL_SAFE_UPDATES = 0;
#--
UPDATE 
  works 
SET 
  salary = salary * 1.1 
WHERE 
  company_name = "first bank corporation";
#check if it worked
SELECT employee_name, salary FROM works WHERE company_name = "first bank corporation" ;
-- Q.3.c Give all managers of first bank corporation a 10 percent raise
# using subquery
UPDATE 
  works 
SET
  salary = salary * 1.1 
WHERE 
  employee_name IN (
    SELECT 
      manager_name 
    FROM 
      manages
  ) 
  AND company_name = "first bank corporation";
#using JOIN
update 
  works w 
  INNER JOIN manages m ON m.manager_name = w.employee_name 
set 
  salary = salary * 1.1 
WHERE 
  w.company_name = "first bank corporation";
# to check 
SELECT 
  * 
FROM 
  works 
WHERE 
  employee_name IN (
    SELECT 
      manager_name 
    FROM 
      manages
  ) 
  AND company_name = "first bank corporation";
-- Q.3.d Give all managers of first bank corporation a 10 percent raise unless the salary becomes greater than $100,000; IN such cASes, give ONly a 3 percent raise.
# IF(cONditiON, value_if_true, value_if_false)
# using subquery
UPDATE
  works 
SET
  salary = if(
    salary * 1.1 > 100000, salary * 1.03, salary * 1.1
  ) 
WHERE 
  employee_name IN (
    SELECT 
      manager_name 
    FROM 
      manages
  ) 
  AND company_name = "first bank corporation";
#using JOIN
UPDATE 
  works w 
  INNER JOIN manages m ON m.manager_name = w.employee_name 
SET
  salary = if(
    salary * 1.1 > 100000, salary * 1.03, salary * 1.1
  ) 
WHERE 
  w.company_name = "first bank corporation";
# to check 
SELECT 
  * 
FROM 
  works 
WHERE 
  employee_name IN (
    SELECT 
      manager_name 
    FROM 
      manages
  ) 
  AND company_name = "first bank corporation";
-- Q.3.e Delete all tuples IN the works relatiON for employees of Small Bank corporation.
delete e,m,w 
FROM 
  works w 
  INNER JOIN employee e ON w.employee_name = e.employee_name 
  INNER JOIN manages m ON m.employee_name = w.employee_name 
WHERE 
  w.company_name = "small bank corporation";
#check if the code worked
SELECT 
  * 
FROM 
  works w 
  INNER JOIN employee e ON w.employee_name = e.employee_name 
  INNER JOIN manages m ON m.employee_name = w.employee_name 
WHERE 
  w.company_name = "small bank corporation";