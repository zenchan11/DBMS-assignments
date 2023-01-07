/*
employee(employee-name, street, city)
works(employee-name, company-name, salary)
company(company-name, city)
manages (employee-name, manager-name)
*/

/*
1. Give an SQL schema definition for the employee database of Figure 5. Choose an appropriate
primary key for each relation schema, and insert any other integrity constraints (for example,
foreign keys) you find necessary.
*/

CREATE DATABASE db_employees;
USE db_employees;

CREATE TABLE tbl_employee (
    employee_name VARCHAR(32) NOT NULL PRIMARY KEY,
    street VARCHAR(32),
    city VARCHAR(32)
);


CREATE TABLE tbl_Company (
    company_name VARCHAR(32) NOT NULL PRIMARY KEY,
    city VARCHAR(32)
);


CREATE TABLE Tbl_works (
    employee_name VARCHAR(32) NOT NULL PRIMARY KEY,
    company_name VARCHAR(32),
    salary INT,
    FOREIGN KEY (employee_name)
        REFERENCES tbl_employee (employee_name),
    FOREIGN KEY (company_name)
        REFERENCES tbl_Company (company_name)
);



CREATE TABLE tbl_manages (
    employee_name VARCHAR(32) NOT NULL PRIMARY KEY,
    manager_name VARCHAR(32) NOT NULL,
    FOREIGN KEY (employee_name)
        REFERENCES tbl_employee (employee_name)
);
