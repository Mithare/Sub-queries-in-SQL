create table employee (
EmployeeID int,
EmployeeName varchar,
DepartmentID int,
Salary int);

insert into employee values
(1, 'John', 1, 50000),
(2, 'Jane', 1, 55000),
(3, 'Michael', 2, 60000),
(4, 'Sarah', 2, 65000),
(5, 'David', 3, 70000);

select * from employee;


create table department (
DepartmentID int,
DepartmentName varchar);

insert into department values
(1, 'Sales'),
(2, 'Marketing'),
(3, 'Finance');


select * from employee;
select * from department;


--Find the employees whoose salary is more than the average salary

select avg(salary) from employee;

select * from employee
where salary > (select avg(salary) from employee);


--Scalar subquery - It will always return one row and one column.

select e.*
from employee as e
join (select avg(salary) as sal from employee) as avg_sal
on e.salary > avg_sal.sal;

--Multiple row subquery - It returns multiple rows and columns or returns 1 row and multiple columns.

--QUESTION: Find the employees who earn highest salary in each department.


select *
from employee
where (salary, departmentid) in (select max(salary), departmentid
from employee
group by 2);


--Single column multiple row sub query
--Find the department who do not have any employees.

select *
from department
where departmentid not in (select distinct departmentid from employee);


--Correlated sub query - It is a sub query related to the outer query.
--QUESTION: Find the employees in each department who earn more than avg salary in that department.

select *
from employee as e1
where salary > (select avg(salary)
				from employee as e2
				where e1.departmentid = e2.departmentid);
				

--Find department who do not have any employees.

select *
from department as d
where not exists (select * from employee as e where e.departmentid = d.departmentid);

--Create sales table

create table Stores (
Store_ID int,
Store_Name varchar,
Product_Name varchar,
Quantity int,
Price int);

insert into Stores values
(1, 'Store A', 'X', 10, 10.99),
(1, 'Store A', 'Y', 5, 7.99),
(1, 'Store A', 'Z', 2, 5.49),
(2, 'Store B', 'X', 8, 10.99),
(2, 'Store B', 'Z', 3, 5.49),
(3, 'Store C', 'Y', 6, 7.99),
(3, 'Store C', 'Z', 4, 5.49);


select * from stores;


-- Find the store whose sales are better than the avg sales across all stores.

select *
from (select store_name, sum(price) as sum_sales
	  from stores
	  group by 1) as A
join (select avg(sum_sales) as avg_sales
	  from (select store_name, sum(price) as sum_sales
	  		from stores
	  		group by 1) as X) as B
on A.sum_sales > B.avg_sales;

--The right way to write a above query is 

with cte as 
(select store_name, sum(price) as sum_sales
from stores
group by 1)
	  
select *
from cte as A
join (select avg(sum_sales) as avg_sales
	  from cte) as B
on A.sum_sales > B.avg_sales;


--Using sub query in select clause

--Fetch all the details and add remarks to thoose employees who earn more than the avg salary.

select *, (case when salary > (select avg(salary) from employee) then 'Higher salary'
		  else 'Lower salary'
		  end) as remarks
from employee;

-- But the method is not an efficient way to write a query because for every single record it will process with entire table.

select *, (case when salary > avg_salary then 'Higher salary' else 'Lower salary' end) as remarks
from employee
cross join (select avg(salary) as avg_salary from employee) as A;


--Select query in HAVING clause.

--Find the stores who have sold more units than the avg units sold by all stores.

select store_name, sum(quantity)
from stores
group by 1
having sum(quantity) > (select avg(quantity) from stores);