SELECT 
    product_category_name_english,
    COUNT(product_id) AS product_count
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english
ORDER BY product_count DESC;

-- Which 10 product categories contain the most products?
SELECT 
    product_category_name_english,
    COUNT(product_id) AS product_count
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english
ORDER BY product_count DESC
LIMIT 10;

-- How many products have a missing product category?
SELECT 
    COUNT(*) AS num_missing_product
FROM
    products
WHERE
    product_category_name IS NULL;

-- How many unique product categories are there?
SELECT 
    COUNT(DISTINCT product_category_name) AS UNIQUE_product_category
FROM
    products;

-- What percentage of products belong to each product category?
WITH prod_category AS (
	SELECT 	product_category_name_english,
		COUNT(product_id) AS product_count
	FROM products p
	JOIN product_category_translation pct
	ON p.product_category_name = pct.product_category_name
	GROUP BY product_category_name_english
)
SELECT product_category_name_english,
	ROUND(product_count/SUM(product_count) OVER() * 100 ,4) as percentageof_product
FROM prod_category
GROUP BY product_category_name_english;

SELECT 
    product_category_name_english,
    ROUND(AVG(product_weight_g), 4) AS avg_weight_in_gram
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english
ORDER BY avg_weight_in_gram DESC;

-- Which 10 product categories have the highest average product weight?
SELECT 
    product_category_name_english,
    ROUND(AVG(product_weight_g), 4) AS avg_weight_in_gram
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english
ORDER BY avg_weight_in_gram DESC
LIMIT 10;

-- Which 10 product categories have the lowest average product weight?
SELECT 
    product_category_name_english,
    ROUND(AVG(product_weight_g), 4) AS avg_weight_in_gram
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english
ORDER BY avg_weight_in_gram ASC
LIMIT 10;

-- What is the average number of photos per product category?
SELECT 
    product_category_name_english,
    ROUND(AVG(product_photos_qty), 4) AS avg_num_photo
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english;

-- Which product categories have the highest average number of photos?
SELECT 
    product_category_name_english,
    ROUND(AVG(product_photos_qty), 4) AS avg_num_photo
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english
ORDER BY avg_num_photo DESC;

-- What are the average product dimensions (length, height, and width) by category?
SELECT 
    product_category_name_english,
    ROUND(AVG(product_length_cm), 2) AS avg_product_length_cm,
    ROUND(AVG(product_height_cm), 2) AS avg_product_height_cm,
    ROUND(AVG(product_width_cm), 2) AS avg_product_width_cm
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY product_category_name_english;

SELECT 
    COUNT(*) AS unsold_products
FROM
    products p
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
WHERE
    oi.product_id IS NULL;

SELECT 
    product_category_name_english,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
        JOIN
    order_items oi ON p.product_id = oi.product_id
        JOIN
    order_reviews orw ON oi.order_id = orw.order_id
GROUP BY product_category_name_english
ORDER BY avg_review_score DESC;

-- Which product categories have the lowest average review score?
SELECT 
    product_category_name_english,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
        JOIN
    order_items oi ON p.product_id = oi.product_id
        JOIN
    order_reviews orw ON oi.order_id = orw.order_id
GROUP BY product_category_name_english
ORDER BY avg_review_score ASC;

-- Which products have received the most reviews?
SELECT 
    p.product_id, COUNT(review_id) AS num_reviews
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
        JOIN
    order_reviews orw ON oi.order_id = orw.order_id
GROUP BY p.product_id
ORDER BY num_reviews DESC
LIMIT 10;

SELECT 
    product_category_name_english,
    ROUND(SUM(price) / COUNT(DISTINCT p.product_id), 4) AS sales_per_product
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
        JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY product_category_name_english
ORDER BY sales_per_product DESC;

