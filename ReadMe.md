# Zepto E-commerce SQL Data Analyst Portfolio Project

Hi, I’m Thella Vamsi Vardhan.

This is an end-to-end SQL Data Analyst portfolio project based on a real-world e-commerce inventory dataset scraped from Zepto, one of India’s fastest-growing quick-commerce startups.

The objective of this project is to simulate how a data analyst works in a retail or e-commerce environment — starting from raw inventory data and transforming it into meaningful business insights using SQL.

---

## Project Objective

The goal of this project is to:

- Design and create a structured database  
- Perform exploratory data analysis (EDA)  
- Clean and standardize messy real-world data  
- Write business-focused SQL queries  
- Derive insights related to pricing, inventory, stock, and revenue  

This project is useful for data analyst aspirants, SQL learners, and candidates preparing for interviews in retail, e-commerce, or product analytics.

---

## Dataset Overview

The dataset was sourced from Kaggle and originally scraped from Zepto’s product listings.

Each row represents a unique SKU (Stock Keeping Unit). Duplicate product names exist because the same product may appear in different weights, package sizes, discounts, or categories — which reflects real-world catalog behavior in e-commerce systems.

### Columns

- **sku_id** – Unique identifier (Primary Key)  
- **name** – Product name  
- **category** – Product category  
- **mrp** – Maximum Retail Price (converted from paise to rupees)  
- **discountPercent** – Discount percentage applied  
- **discountedSellingPrice** – Final selling price after discount  
- **availableQuantity** – Units available in inventory  
- **weightInGms** – Product weight in grams  
- **outOfStock** – Boolean flag for stock availability  
- **quantity** – Number of units per package  

---

## Database Creation

```sql
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

## Data Import

The dataset was imported using pgAdmin.

An encoding issue (UTF-8 error) occurred during import. This was resolved by saving the CSV file in UTF-8 format before loading it into PostgreSQL.

---

## Exploratory Data Analysis (EDA)

Performed the following checks:

- Counted total records  
- Checked for null values  
- Identified distinct product categories  
- Compared in-stock vs out-of-stock counts  
- Detected duplicate product names across SKUs  

This helped understand the data structure and identify inconsistencies.

---

## Data Cleaning

The following cleaning steps were applied:

- Removed records where MRP or selling price was zero  
- Converted pricing from paise to rupees  
- Standardized numeric columns  
- Ensured proper aggregation under strict SQL mode  

---

## Business Insights Generated

Using SQL, the following insights were derived:

- Top 10 products with highest discount percentages  
- High-MRP products currently out of stock  
- Estimated revenue by category  
- Expensive products (MRP > ₹500) with minimal discount  
- Top 5 categories with highest average discounts  
- Price per gram analysis  
- Weight-based product segmentation (Low, Medium, Bulk)  
- Total inventory weight per category  

### Example: Revenue Calculation

Revenue = Selling Price × Quantity

```sql
SELECT
    category,
    SUM(discountedSellingPrice * quantity) AS total_revenue
FROM zepto
GROUP BY category;