-- Which states have the most customers?

SELECT customer_state,
	COUNT(*) as num_of_customers
FROM customers
GROUP BY customer_state
ORDER BY num_of_customers DESC;

-- Which 10 cities have the most customers?

SELECT customer_city,
	COUNT(*) as num_of_customers
FROM customers
GROUP BY customer_city
ORDER BY num_of_customers DESC
LIMIT 10;

-- What is the difference between total customer_id and distinct customer_unique_id?

SELECT (COUNT(DISTINCT customer_id) -
	COUNT(DISTINCT customer_unique_id)) as difference	
FROM customers;

-- How many orders does each customer place?


SELECT customer_unique_id,
    COUNT(DISTINCT order_id) AS number_of_orders
FROM orders o 
join customers c
on o.customer_id = c.customer_id
GROUP BY customer_unique_id
ORDER BY number_of_orders DESC;

-- How many customers are repeat customers (more than 1 order)?

SELECT COUNT(customer_unique_id) as repeated_customers
FROM (
SELECT customer_unique_id,
    COUNT(DISTINCT order_id) AS number_of_orders
FROM orders o 
join customers c
on o.customer_id = c.customer_id
GROUP BY customer_unique_id
HAVING number_of_orders > 1
) as number_of_orders_table;

-- What percentage of customers are repeat customers?

WITH customer_orders AS (
SELECT customer_unique_id,
    COUNT(DISTINCT order_id) AS number_of_orders
FROM orders o 
join customers c
on o.customer_id = c.customer_id
GROUP BY customer_unique_id
)
SELECT
	COUNT(CASE WHEN number_of_orders>1 THEN 1 END)  as repeated_customers,
	count(*) ,
    (COUNT(CASE WHEN number_of_orders>1 THEN 1 END)/
		COUNT(*) * 100.0) as percentage_repeated_customers
from customer_orders;

-- Which states have the most orders? → requires customers + orders

SELECT customer_state,
	COUNT(distinct o.order_id) AS number_of_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY customer_state
ORDER BY number_of_orders DESC
;

-- What is the average number of orders per customer?
WITH customer_orders AS ( 
	SELECT customer_unique_id,
		COUNT(DISTINCT order_id) AS number_of_orders
	FROM orders o 
	join customers c
	on o.customer_id = c.customer_id
	GROUP BY customer_unique_id
	)
SELECT ROUND(AVG(number_of_orders),4) as avg_order_per_customer
FROM customer_orders
;

-- What is the maximum number of orders placed by a single customer?

SELECT customer_unique_id,
	COUNT(DISTINCT order_id) AS number_of_orders
FROM orders o 
join customers c
on o.customer_id = c.customer_id
GROUP BY customer_unique_id
ORDER BY number_of_orders DESC
LIMIT 1;
