
--1. Create a list of employees with their full names in uppercase.
select upper (concat(Firstname, ' ', Lastname)) as Fullname
from employees
--OR
select upper (Firstname + ' ' + Lastname) as Fullname
from employees


--2. List customer initials (first letter of FirstName and LastName).
select substring (Firstname,1,1) +'.'+ substring (Lastname,1,1) as Initials
--Concat (substring (Firstname,1,1),substring (Lastname,1,1)) as Initials 
from customers


--3. Return customer email addresses in lowercase.
select lower (Email)  as Email
from customers

--4. Generate a report showing each employee’s full name and the total value of orders they have processed.
--   Ensure that employees who haven’t handled any orders are still included in the result, and display 0 as 
--   their total processed amount instead of NULL.
select e.Employeeid, concat (e.Firstname, ' ', e.Lastname) as Fullname, 
coalesce (round (sum(o.orderamount),2), 0) as TotalValue
from employees e
left join orders o
on e.employeeid = o.employeeid
group by e.employeeid, e.firstname, e.lastname


--6. Convert salaries to decimal with 2 decimal places.
-- Cast (Expression, Datatype)
select Employeeid, cast (salary as decimal (10,2)) as SalaryinDecimal
from employees

--7. Care Global wants to send out appreciation messages to employees based on the day of the week they were 
--   hired. Write a query to display each employee's full name, hire date, and the day name (e.g., Monday, Tuesday) they were hired.
select concat (firstname, ' ', lastname) as Fullname, Hiredate, datename (weekday, hiredate) as Dayhired
from employees
--where datename (weekday, hiredate) = 'monday' 
--or datename (weekday, hiredate) ='friday'


--1. The manager wants to reward employees who have been with the company for more than 8 years. Identify 
--   those employees by calculating how long each person has worked at Care Global, using today's date as a reference.
select concat (firstname, ' ', lastname) as Fullname, datediff (year, hiredate, getdate()) as Years_in_Company
from employees
where datediff (year, hiredate, getdate()) > 8
order by Years_in_Company


--Trying Getdate and cast function
select getdate() as CurrentDate_Time, cast(getdate() as Date) as CurrentDate
from employees

--2. The sales director is planning a campaign targeting recent customer signups. Find customers who joined within the last 6 months from today.
select Customerid, concat (firstname, ' ', lastname) as Fullname, Joindate, datediff (month, joindate, getdate()) as Months_in_Company
from customers
where datediff (month, joindate, getdate()) <= 6

--OR using GetDate function
select Customerid, concat (firstname, ' ', lastname) as Fullname, Joindate, dateadd (month, -6, getdate()) as Months_in_Company
from customers
where joindate >= dateadd (month, -6, getdate())


--3. You’re asked to evaluate sales growth month by month. Create a summary showing the total number of 
--   orders for each month and year from the Orders table.
Select Distinct(Datename (month, orderdate)) as Monthname, sum (month (orderdate)) as MonthlyOrder, sum (year (orderdate)) as YearlyOrder
from orders
group by orderdate
order by MonthlyOrder 

--OR 
SELECT YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) As OrderMonth,
COUNT(orderId) AS Total_Order
FROM orders
GROUP BY YEAR(OrderDate), Month(OrderDate)
ORDER BY orderYear, OrderMonth;

select *
from orders

--4. To monitor daily performance, your team needs a breakdown of total sales per day. Write a query that shows 
--   the OrderDate, number of orders, and total amount for each date.
select  Orderdate, count (orderid) as NumOfOrders, round (sum (orderamount), 2) as OrderAmount
from orders
group by orderdate
order by Orderdate desc


--5. Finance is analyzing order trends by quarter. Create a report showing the quarter (Q1–Q4) in which each order 
--   was placed, along with the total revenue for each quarter.
select Datepart (

--1. HR wants to know how long it’s been since each employee was hired. Return a list of employees with a new
--   column showing the number of days they have been with the company.
select Employeeid, Firstname, Lastname, 
from Employees

--2. Care Global wants to reward employees based on how long they’ve worked. Write a query that classifies each
--   employee as “New” if hired within the last year, “Mid-level” if hired between 2 and 7 years, and “Experienced” if above 7 years.

select EmployeeId, FirstName+' '+LastName AS FullName, HireDate,
CASE
	WHEN DATEDIFF(YEAR,HireDate,GETDATE()) < 2  THEN 'New'
	WHEN DATEDIFF(YEAR,HireDate,Getdate()) BETWEEN 2 AND 7 THEN 'Mid-Level'
	ELSE 'Experienced'
END AS TenureStatus
FROM employees;

--3. A recent policy change categorizes orders based on their value: 'High' for amounts above ₦4000, 'Medium'
--   for ₦2,000 to ₦4,000, and 'Low' for anything below ₦2,000. Create a query that assigns each order to its appropriate category.
select Orderid, round (orderamount, 2) as OrderAmount,
case
 when orderamount > '4000' then 'High'
 when orderamount between '2000' and '4000' then 'Medium'
 else 'Low'
end as OrderCategory
from orders
Order by OrderAmount 

--4. The company is reviewing customer loyalty. Tag each customer as “Recent” if they joined in 2024, “Returning” if 
--   they joined Within 2023 to 2021, and “Old” if before 2020.
Select Customerid, Firstname, Lastname, Joindate,
case
when Year(Joindate) >= '2024' then 'Recent'
when year(joindate) between '2021' and '2023' then 'Returning'
else 'Old'
End as Loyalty
from customers
order by joindate desc

--5. Some employees earn higher salaries than others in their department. Write a query that identifies each
--   employee and states whether they are earning “Above Average”, “Below Average”, or “Average” within their department.
select avg(Salary) as AverageSalary
from employees

Select Employeeid, Department, avg(Salary) as AverageSalary,
case
when Salary > '75292' then 'Above Average'
when Salary < '75292' then 'Below Average'
else 'Average'
End as Salary_Level
from Employees
Group by Employeeid, Department, Salary
order by AverageSalary
