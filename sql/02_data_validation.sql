use olist_ecommerce;

-- ********************
-- Row Count Validation
-- ********************

SELECT 'customers' as table_name ,COUNT(*) FROM customers
UNION ALL
SELECT 'geolocation',COUNT(*) FROM geolocation
UNION ALL
SELECT 'order_items',COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments',COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews',COUNT(*) FROM order_reviews
UNION ALL
SELECT 'orders',COUNT(*) FROM orders
UNION ALL
SELECT 'product_category_translation',COUNT(*) FROM product_category_translation
UNION ALL
SELECT 'products',COUNT(*) FROM products
UNION ALL
SELECT 'sellers',COUNT(*) FROM sellers
;

-- *********************
-- NULL Value Validation
-- *********************

SELECT 'customer' as table_name,COUNT(*) as null_values FROM customers
WHERE customer_id IS NULL
UNION ALL
SELECT 'orders' as table_name,COUNT(*) as null_values FROM orders
WHERE order_id IS NULL
UNION ALL
SELECT 'order_items' as table_name,COUNT(*) as null_values FROM order_items
WHERE order_item_id IS NULL
UNION ALL
SELECT 'products' as table_name,COUNT(*) as null_values FROM products
WHERE product_id IS NULL
UNION ALL
SELECT 'sellers' as table_name,COUNT(*) as null_values FROM sellers
WHERE seller_id IS NULL
;


-- *********************
-- Duplicate Validation
-- *********************

SELECT customer_id,COUNT(*) as occurences FROM customers
GROUP BY customer_id
HAVING COUNT(*)>1;

SELECT order_id,COUNT(*) as occerences FROM orders
GROUP BY order_id
HAVING COUNT(*)>1;

SELECT review_id ,COUNT(*) as occerences FROM order_reviews
GROUP BY review_id 
HAVING COUNT(*)>1;
## review_id have duplicated review_id's 

SELECT product_id ,COUNT(*) as occerences FROM products
GROUP BY product_id
HAVING COUNT(*)>1;

SELECT seller_id,COUNT(*) as occerences FROM sellers
GROUP BY seller_id
HAVING COUNT(*)>1;

SELECT order_id,order_item_id ,COUNT(*) as occerences FROM order_items
GROUP BY order_id,order_item_id 
HAVING COUNT(*)>1;
;

SELECT COUNT(*) AS duplicate_review_ids
FROM (
    SELECT review_id
    FROM order_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    review_id,
    COUNT(*) AS occurrences
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) = 3
LIMIT 1;

SELECT * FROM order_reviews
WHERE review_id = 'c444278834184f72b1484dfe47de7f97';
-- review_id is not a primary key

SELECT review_id,order_id,COUNT(*) AS occurrences
FROM order_reviews
GROUP BY review_id, order_id
HAVING COUNT(*) > 1
LIMIT 10;
-- PRIMARY KEY (review_id,order_id)

-- ****************************
-- 5. VALUE / RANGE VALIDATION
-- ****************************

-- Review score should be between 1 and 5
SELECT COUNT(*) AS invalid_review_scores
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;


-- Product prices should not be negative
SELECT COUNT(*) AS negative_prices
FROM order_items
WHERE price < 0;


-- Freight value should not be negative
SELECT COUNT(*) AS negative_freight_values
FROM order_items
WHERE freight_value < 0;


-- Payment values should not be negative
SELECT COUNT(*) AS negative_payment_values
FROM order_payments
WHERE payment_value < 0;


-- Payment installments should be positive
SELECT COUNT(*) AS invalid_installments
FROM order_payments
WHERE payment_installments < 0;


-- Product dimensions should not be negative
SELECT COUNT(*) AS invalid_product_dimensions
FROM products
WHERE product_weight_g < 0
   OR product_length_cm < 0
   OR product_height_cm < 0
   OR product_width_cm < 0;

-- ****************************
-- DATE CONSISTENCY VALIDATION
-- ****************************


-- Approved date should not be before purchase date
SELECT COUNT(*) AS invalid_approval_dates
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;


-- Carrier delivery date should not be before approval date
SELECT COUNT(*) AS invalid_carrier_dates
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;

SELECT * FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
LIMIT 20;

-- Customer delivery date should not be before carrier delivery
SELECT COUNT(*) AS invalid_customer_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

SELECT * FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

-- Estimated delivery should not be before purchase date
SELECT COUNT(*) AS invalid_estimated_delivery_dates
FROM orders
WHERE order_estimated_delivery_date IS NOT NULL
  AND order_estimated_delivery_date < order_purchase_timestamp;
  
  
