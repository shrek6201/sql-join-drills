CREATE DATABASE JoinPractice;
GO
USE JoinPractice;
GO

CREATE TABLE customers (
	customer_id INT PRIMARY KEY,
	name NVARCHAR(50),
	city NVARCHAR(50) NULL
);

CREATE TABLE orders (
	order_id INT PRIMARY KEY,
	customer_id INT NULL,
	amount DECIMAL(20)
);

CREATE TABLE employees (
	emp_id INT PRIMARY KEY,
	name NVARCHAR(50),
	manager_id INT NULL
);

INSERT INTO customers VALUES
 (1,'Asha','Pune'), (2,'Ben','Dublin'), (3,'Chen',NULL),
 (4,'Dana','Cork'), (5,'Eli','Pune');

INSERT INTO orders VALUES
 (101,1,250), (102,1,100), (103,2,75), (104,3,300), (105,NULL,50), (106,99,20), (107,NULL,60);

INSERT INTO employees VALUES
 (1,'Priya',NULL), (2,'Raj',1), (3,'Meera',1), (4,'Sam',2);

-- INNER: only rows matching on both sides. Unmatches customers and orders, and NULL keys, are dropped. Expected 4
SELECT c.name, o.order_id FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- LEFT: all customers kept. Dana and Eli get NULL order_id because they have no orders. Expected 6
SELECT c.name, o.order_id FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT: all orders are kept. Orders with NULL or unknown customers get NULL name. 7 are expected
SELECT c.name, o.order_id FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- FULL: everything from both the sides is matched where possible. 9 entries expected
SELECT c.name, o.order_id FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

-- CROSS: every customer is paired with every order. 5*7 = 35 expected
SELECT c.name, o.order_id FROM customers c CROSS JOIN orders o;

-- SELF(inner): employee joined to their managers and Priya has no manager so she is excluded.
SELECT e.name AS employee, m.name AS manager
FROM employees e INNER JOIN employees m ON e.manager_id = m.emp_id;

-- SELF(left): same as SELF(inner) but Priya is kept with a NULL manager.
SELECT e.name AS employee, m.name AS manager
FROM employees e LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Anti(LEFT + IS NULL): customer with no matching order
SELECT c.name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Anti(NOT EXISTS): same result and also safe with NULLs
SELECT name from customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- Anti(NOT IN): returns nothing because the subquery contains NULL, so the comparison is not known.
SELECT name FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

-- ON vs WHERE in a LEFT JOIN
-- Filter in ON: filter is applied while matching so all the customers stay.
SELECT c.name, o.order_id FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.amount > 100;

-- Filter in WHERE: filter applied after the join so NULL rows are removed
SELECT c.name, o.order_id FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount > 100;
