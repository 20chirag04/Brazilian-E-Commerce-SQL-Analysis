USE olist_ecommerce;

## Updating Primary Key which was missed before
ALTER TABLE order_reviews
ADD PRIMARY KEY (review_id, order_id);


## Table -> Customer 
ALTER TABLE customers
MODIFY customer_id VARCHAR(32) NOT NULL,
MODIFY customer_unique_id VARCHAR(32);

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

## Table -> Order
ALTER TABLE orders
MODIFY order_id VARCHAR(32) NOT NULL,
MODIFY customer_id VARCHAR(32) NOT NULL,
ADD PRIMARY KEY (order_id),
ADD FOREIGN KEY (customer_id)
	REFERENCES customers(customer_id);
    
ALTER TABLE orders
MODIFY order_purchase_timestamp DATETIME,
MODIFY order_approved_at DATETIME,
MODIFY order_delivered_carrier_date DATETIME,
MODIFY order_estimated_delivery_date DATETIME,
MODIFY order_delivered_customer_date DATETIME;


## Table -> Order_items
ALTER TABLE order_items
MODIFY order_id VARCHAR(32) NOT NULL,
MODIFY product_id VARCHAR(32),
MODIFY seller_id VARCHAR(32);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_item_id
	FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
ADD CONSTRAINT fk_product_item_id
	FOREIGN KEY (product_id)
	REFERENCES products(product_id),
ADD CONSTRAINT fk_seller_item_id
	FOREIGN KEY (seller_id)
	REFERENCES sellers(seller_id);
    
ALTER TABLE order_items
MODIFY shipping_limit_date DATETIME;

## Table -> Order_payments
ALTER TABLE order_payments
MODIFY order_id VARCHAR(32) NOT NULL;
ALTER TABLE order_payments
ADD CONSTRAINT fk_order_payment
	FOREIGN KEY (order_id)
	REFERENCES orders(order_id);
    
## Table -> Order_reviews
ALTER TABLE order_reviews
ADD CONSTRAINT fk_order_reviews 
	FOREIGN KEY (order_id)
	REFERENCES orders(order_id);
    
ALTER TABLE order_reviews
MODIFY review_creation_date DATETIME,
MODIFY review_answer_timestamp DATETIME;

## TABLE -> Prodcuts
ALTER TABLE products
MODIFY product_id VARCHAR(32) NOT NULL,
MODIFY product_category_name VARCHAR(47);
ALTER TABLE products
ADD PRIMARY KEY (product_id);
ALTER TABLE products
ADD	FOREIGN KEY (product_category_name)
    REFERENCES product_category_translation(product_category_name);


## TABLEc-> Sellers
ALTER TABLE sellers
MODIFY seller_id VARCHAR(32) NOT NULL;
ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

## TABLE -> product_category_translation
ALTER TABLE product_category_translation
MODIFY product_category_name VARCHAR(47) NOT NULL;
ALTER TABLE product_category_translation
ADD PRIMARY KEY (product_category_name);


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(
        geolocation_zip_code_prefix, '|',
        geolocation_lat, '|',
        geolocation_lng, '|',
        geolocation_city, '|',
        geolocation_state
    )) AS unique_combinations
FROM geolocation;







