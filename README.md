# Olist Brazilian E-Commerce SQL Analysis

## Overview

An end-to-end **SQL analysis of the Brazilian Olist E-Commerce dataset** using MySQL.

The project explores customer behavior, sales, products, sellers, freight, reviews, and delivery performance, with the goal of turning raw transactional data into meaningful business insights.

## Dataset

**Source:** [Olist Brazilian E-Commerce Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?utm_source=chatgpt.com)

The dataset contains approximately **100K orders** along with customer, product, seller, payment, review, and shipping information.

## Tools & Skills

* MySQL
* MySQL Workbench
* SQL
* Git & GitHub

### SQL Concepts

`JOINs` · `GROUP BY` · `HAVING` · `CTEs` · `Subqueries` · `Window Functions` · `CASE` · Aggregate Functions · Date Functions

## Project Structure

```text id="3m4v5c"
Olist-Ecommerce-SQL-Analysis/
│
├── data/
│   └── raw/
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_table_creation.sql
│   ├── 03_data_validation.sql
│   ├── 04_exploratory_analysis.sql
│   ├── 05_customer_analysis.sql
│   ├── 06_sales_analysis.sql
│   ├── 07_product_analysis.sql
│   ├── 08_seller_analysis.sql
│   └── 09_business_insights.sql
│
└── README.md
```

## Analysis

The project covers:

* Customer behavior and repeat customers
* Sales and order trends
* Product and category performance
* Seller performance
* Freight costs
* Product reviews
* Delivery performance
* State-level market analysis
* Business insights

## Key Insights

* **São Paulo (SP)** is the strongest market by customer and sales activity.
* **Health & Beauty** is among the strongest-performing product categories.
* A relatively small group of sellers contributes significantly to total revenue.
* **Repeat customers generate higher average revenue per customer** than one-time customers.
* Higher freight-to-product-price ratios are associated with lower sales values.
* Delivery performance shows an association with customer review scores.

## Author

**Chirag Sharma**
B.Tech Computer Science | Aspiring Data Analyst
