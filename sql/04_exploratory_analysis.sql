use olist_ecommerce;

### Overall Database Size ###

SELECT 'customers' as table_name, COUNT(*) as total_count FROM customers
UNION ALL
SELECT 'orders' as table_name, COUNT(*) as total_count FROM orders
UNION ALL
SELECT 'order_items' as table_name, COUNT(*) as total_count FROM order_items
UNION ALL
SELECT 'order_payments' as table_name, COUNT(*) as total_count FROM order_payments
UNION ALL
SELECT 'order_reviews' as table_name, COUNT(*) as total_count FROM order_reviews
UNION ALL
SELECT 'geolocation' as table_name, COUNT(*) as total_count FROM geolocation
UNION ALL
SELECT 'product_category_translation' as table_name, COUNT(*) as total_count FROM product_category_translation
UNION ALL
SELECT 'products' as table_name, COUNT(*) as total_count FROM products
UNION ALL
SELECT 'sellers' as table_name, COUNT(*) as total_count FROM sellers;

## Customers
SELECT * FROM customers;
SELECT COUNT(DISTINCT customer_city) as number_of_cities,
		COUNT(DISTINCT customer_state) as number_of_states,
		COUNT(DISTINCT customer_zip_code_prefix) as customer_zip_code_prefix
from customers;

SELECT COUNT(DISTINCT customer_unique_id) FROM customers;

SELECT * FROM customers
WHERE customer_unique_id IS NULL;

SELECT COUNT(*) as total_customer, customer_state
FROM customers
GROUP BY customer_state
ORDER BY total_customer DESC;

SELECT COUNT(*) as total_customer, customer_city 
FROM customers
GROUP BY customer_city
HAVING total_customer >100
ORDER BY total_customer DESC;

SELECT COUNT(*) as total_customer, customer_state, customer_city
FROM customers
GROUP BY customer_state,customer_city
ORDER BY total_customer DESC;

### Order Reviews ###

SELECT * FROM orders;

DESCRIBE orders;

SELECT COUNT(DISTINCT order_status)
FROM orders;

SELECT order_status,count(order_id) as total_num_orders
FROM orders
GROUP BY order_status
ORDER BY total_num_orders DESC;

SELECT order_status,
		order_id,
        order_delivered_customer_date,
        order_delivered_carrier_date 
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

SELECT COUNT(*) AS invalid_carrier_dates
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;

SELECT order_status,order_delivered_carrier_date,order_approved_at 
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;

-- Data-quality anomaly detected.
-- Original values are retained because the correct replacement
-- value cannot be determined reliably from the available data.

## Table order_items

SELECT * FROM order_items;

SELECT DISTINCT order_item_id FROM order_items;

SELECT count(DISTINCT order_id) FROM order_items;

SELECT
    number_of_items,
    COUNT(*) AS number_of_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS number_of_items
    FROM order_items
    GROUP BY order_id
) AS order_item_counts
GROUP BY number_of_items
ORDER BY number_of_items;


## Table Order Payment 

SELECT * FROM order_payments;

SELECT COUNT(*) FROM order_payments;

SELECT COUNT(DISTINCT payment_sequential),
	COUNT(DISTINCT payment_type),
    COUNT(DISTINCT payment_installments)
FROM order_payments;

SELECT DISTINCT payment_type from order_payments;
### Reviews ###

SELECT * FROM order_reviews;

DESCRIBE order_reviews;

SELECT count(*) FROM order_reviews;

SELECT count(*) FROM order_reviews
where review_comment_title is not null;

SELECT count(*) FROM order_reviews
where review_comment_message is not null;

SELECT review_score,COUNT(*) as num_of_reviews
FROM order_reviews
GROUP BY review_score
order by review_score;

SELECT MIN(review_creation_date) as starting_date ,MAX(review_creation_date) as last_date
FROM order_reviews;

### Product ###

SELECT * FROM products;

SELECT DISTINCT product_category_name FROM products;

SELECT COUNT(*)
FROM products 
WHERE product_category_name is null;

SELECT COUNT(*)
FROM products 
WHERE product_name_lenght is null;

### SELLERS ###

SELECT seller_city,count(*) as total_sellers
FROM sellers
GROUP BY seller_city
ORDER BY total_sellers DESC;

SELECT seller_state,count(*) as total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;
















