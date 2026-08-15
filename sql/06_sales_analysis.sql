use olist_ecommerce;
## Overall Sales

-- What is the total product sales value across all order items?
SELECT ROUND(SUM(price),2) as total_product_sales 
FROM order_items;

-- What is the average product price?
SELECT ROUND(AVG(price),4) as avg_product_price
FROM order_items;

-- What is the total freight value?
SELECT ROUND(SUM(freight_value),2) as total_freight_value
FROM order_items;

-- What is the average freight value per order item?
SELECT ROUND(AVG(freight_value),4) as avg_freight_value
FROM order_items;

## Order Value

-- What is the average order value?
WITH sum_order_value AS (
	SELECT
		order_id,
		SUM(price) AS order_value
	FROM order_items
	GROUP BY order_id
	)
SELECT ROUND(AVG(order_value),4) as avg_order_value
FROM sum_order_value;

-- Which 10 orders have the highest total product value?
SELECT order_id,
	SUM(price) AS total_product_value
FROM order_items
GROUP BY order_id
ORDER BY total_product_value DESC
LIMIT 10;
	

-- What is the minimum and maximum order value?
WITH order_values AS (
    SELECT
        order_id,
        SUM(price) AS order_value
    FROM order_items
    GROUP BY order_id
)
SELECT
    MIN(order_value) AS minimum_order_value,
    MAX(order_value) AS maximum_order_value
FROM order_values;

## Sales by Product

-- Which 10 products generate the highest total sales value?
SELECT product_id,
	SUM(price) AS total_sales_value
FROM order_items
GROUP BY product_id
ORDER BY total_sales_value DESC
LIMIT 10;

-- Which 10 products have the highest number of items sold?
SELECT product_id,
	COUNT(*) AS items
FROM order_items
GROUP BY product_id
ORDER BY items DESC
LIMIT 10;

-- What is the average selling price of the top-selling products?
WITH selling_price AS (
	SELECT product_id,
    	COUNT(*) AS items,
		SUM(price) AS total_sales_value
	FROM order_items
	GROUP BY product_id
	ORDER BY items DESC
    LIMIT 10
)
SELECT ROUND(SUM(total_sales_value)/SUM(items),4) as avg_selling_price
FROM selling_price
;

## Sales by Product Category
-- Which product categories generate the highest sales value?
SELECT product_category_name_english,
	ROUND(sum(price),4) as sales
FROM order_items o
JOIN products p
ON o.product_id = p.product_id
JOIN product_category_translation pct
ON pct.product_category_name = p.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY sales DESC;

-- Which product categories have the highest number of items sold?
SELECT product_category_name_english,
	COUNT(*) as items
FROM order_items o
JOIN products p
ON o.product_id = p.product_id
JOIN product_category_translation pct
ON pct.product_category_name = p.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY items DESC;

-- Which product categories have the highest average product price?
SELECT product_category_name_english,
	ROUND(AVG(price),4) as avg_price
FROM order_items o
JOIN products p
ON o.product_id = p.product_id
JOIN product_category_translation pct
ON pct.product_category_name = p.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY avg_price DESC;


## Sales Over Time
-- How does total sales value change by month?
SELECT YEAR(order_purchase_timestamp) as year_of_purchase,
	MONTH(order_purchase_timestamp) as month_of_purchase,
	ROUND(sum(price),2) as sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month_of_purchase,year_of_purchase
ORDER BY year_of_purchase,month_of_purchase ;

-- Which month generated the highest sales?
SELECT YEAR(order_purchase_timestamp) as year_of_purchase,
	MONTH(order_purchase_timestamp) as month_of_purchase,
	ROUND(sum(price),2) as sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month_of_purchase,year_of_purchase
ORDER BY sales DESC
LIMIT 1;

-- Which month had the highest number of orders?
SELECT YEAR(order_purchase_timestamp) as year_of_purchase,
	MONTH(order_purchase_timestamp) as month_of_purchase,
	COUNT(DISTINCT o.order_id) as number_of_orders
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month_of_purchase,year_of_purchase
ORDER BY number_of_orders DESC
LIMIT 1;

-- What is the average monthly sales value?
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS year_of_purchase,
        MONTH(o.order_purchase_timestamp) AS month_of_purchase,
        SUM(oi.price) AS monthly_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY year_of_purchase, month_of_purchase
)
SELECT
    ROUND(AVG(monthly_sales), 2) AS average_monthly_sales
FROM monthly_sales;

## Freight Analysis
-- Which states have the highest total freight costs?
SELECT customer_state,
	ROUND(SUM(freight_value),2 ) as total_Freight_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY customer_state
ORDER BY total_Freight_value DESC;

-- Which product categories have the highest average freight value?
SELECT product_category_name_english,
	ROUND(AVG(freight_value),2 ) as avg_freight_value
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN product_category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english
ORDER BY avg_freight_value DESC;


-- What percentage of the product sales value is represented by freight?
SELECT ROUND(SUM(freight_value) / SUM(price) * 100,4) AS freight_percentage
FROM order_items;





