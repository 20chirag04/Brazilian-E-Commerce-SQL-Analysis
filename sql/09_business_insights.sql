-- Which state is the strongest market for Olist?
SELECT 
    customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS number_of_customers,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id),
            4) AS avg_order_value
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY customer_state
ORDER BY total_sales DESC
;


-- Which product categories are the most commercially valuable?
SELECT 
    product_category_name_english,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT p.product_id) AS number_of_products,
    COUNT(DISTINCT oi.order_id) AS number_of_orders,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(AVG(oi.price), 4) AS avg_price,
    ROUND(AVG(orw.review_score), 2) AS avg_review_score
FROM
    products p
        JOIN
    product_category_translation pct ON p.product_category_name = pct.product_category_name
        JOIN
    order_items oi ON p.product_id = oi.product_id
        JOIN
    order_reviews orw ON oi.order_id = orw.order_id
GROUP BY product_category_name_english
ORDER BY total_sales DESC
;

-- Which sellers contribute most to revenue?
SELECT 
    s.seller_id,
    COUNT(DISTINCT order_id) AS number_of_orders,
    ROUND(SUM(price), 4) AS total_revenue
FROM
    sellers s
        JOIN
    order_items oi ON s.seller_id = oi.seller_id
GROUP BY seller_id
ORDER BY total_revenue DESC;

-- Are repeat customers more valuable than one-time customers?
with repeat_cust as (
	SELECT customer_unique_id,
		count(distinct o.order_id) as number_of_orders,
		ROUND(SUM(price),2) as total_sales
	from customers c
	join orders o on c.customer_id = o.customer_id
	join order_items oi on o.order_id = oi.order_id
	group by customer_unique_id
	order by total_sales desc
)
SELECT 
	CASE
		WHEN number_of_orders = 1 THEN 'one-time'
		ELSE 'repeat'
	END AS customer_type,
    COUNT(*) AS customers,
    SUM(total_sales) AS total_sales,
    ROUND(AVG(total_sales), 2) AS avg_sales_per_customer
FROM repeat_cust
GROUP BY customer_type;


-- Does freight cost have a meaningful impact on sales?
WITH freight_analysis AS (
    SELECT
        order_id,
        price,
        freight_value,
        ROUND((freight_value / NULLIF(price, 0)) * 100, 2) AS freight_percentage
    FROM order_items
)
SELECT
    CASE
        WHEN freight_percentage < 10 THEN 'Low Freight (<10%)'
        WHEN freight_percentage < 25 THEN 'Medium Freight (10-25%)'
        WHEN freight_percentage < 50 THEN 'High Freight (25-50%)'
        ELSE 'Very High Freight (50%+)'
    END AS freight_category,
    COUNT(*) AS items_sold,
    ROUND(SUM(price), 2) AS total_sales,
    ROUND(AVG(price), 2) AS avg_product_price,
    ROUND(AVG(freight_value), 2) AS avg_freight,
    ROUND(AVG(freight_percentage), 2) AS avg_freight_percentage
FROM freight_analysis
GROUP BY freight_category
ORDER BY
    CASE freight_category
        WHEN 'Low Freight (<10%)' THEN 1
        WHEN 'Medium Freight (10-25%)' THEN 2
        WHEN 'High Freight (25-50%)' THEN 3
        ELSE 4
    END;

-- Does delivery performance affect review scores?
WITH delivery_analysis AS (
    SELECT
        o.order_id,
        DATEDIFF(
            o.order_delivered_customer_date,
            o.order_purchase_timestamp
        ) AS delivery_days,
        orw.review_score
    FROM orders o
    JOIN order_reviews orw
        ON o.order_id = orw.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT
    CASE
        WHEN delivery_days <= 3 THEN 'Fast (≤3 days)'
        WHEN delivery_days <= 7 THEN 'Normal (4–7 days)'
        WHEN delivery_days <= 14 THEN 'Slow (8–14 days)'
        ELSE 'Very Slow (>14 days)'
    END AS delivery_category,
    COUNT(*) AS orders,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM delivery_analysis
GROUP BY delivery_category
ORDER BY avg_delivery_days;

-- Which States have high customer counts but relatively low revenue per customer?
WITH state_performance AS (
    SELECT
        c.customer_state,
        COUNT(DISTINCT c.customer_unique_id) AS number_of_customers,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_state
)
SELECT
    customer_state,
    number_of_customers,
    ROUND(total_revenue, 2) as total_revenue,
    ROUND(total_revenue / number_of_customers, 2) AS revenue_per_customer
FROM state_performance
ORDER BY number_of_customers desc;

# What are the top 5 business insights from the entire dataset?

-- 1. São Paulo (SP) is the strongest market, dominating customer count,
--    order volume, and total sales.

-- 2. Health & Beauty is one of the strongest product categories,
--    combining high sales, strong demand, and good customer satisfaction.

-- 3. A relatively small group of high-performing sellers contributes
--    significantly to total revenue, with some sellers processing
--    more than 1,000 orders.

-- 4. Repeat customers generate higher average sales per customer than
--    one-time customers, although one-time customers represent a much
--    larger portion of the customer base.

-- 5. Higher freight-to-product-price ratios are associated with lower
--    sales values, while delivery performance is also associated with
--    customer review scores, highlighting logistics as an important
--    area for improvement. 