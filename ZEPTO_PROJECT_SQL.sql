Drop table if exists zepto;
CREATE TABLE zepto(
    sku_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Category VARCHAR(120),
    name VARCHAR(150),
    mrp FLOAT(8,2) NOT NULL,
    discountPercent FLOAT(5,2),
    availableQuantity INT,
    discountedSellingPrice INT,
    weightInGms INT,
    outOfStock TINYINT(1),
    quantity INT
);

-- DATA CLEANING
ALTER TABLE zepto
CHANGE COLUMN `ï»¿Category` Category VARCHAR(150);
SELECT * FROM ZEPTO;

-- DATA EXPLORATION
-- TOTAL ROWS
select count(*) from zepto; -- 3728

-- NULL VALUES
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL; -- NO NULL VALUES

-- different product categories
select Category from zepto
group by Category; -- 14 row(s) returned

-- products in stock vs out of stock
select outOfStock,
sum(CASE WHEN outOfStock = FALSE then 1 end) as out_of_stock,
sum(case when outOfStock = TRUE then 0 end) as in_stock
from zepto
group by outOfStock;

SELECT
(SELECT COUNT(outOfStock) from zepto
where outOfStock = FALSE) AS OUT_OF_STOCK,
(SELECT COUNT(outOfStock) from zepto
where outOfStock = TRUE) AS IN_STOCK;

-- product names present multiple times
 select name,count(*) as total from zepto
 group by name
 having count(*) > 1
 order by count(*) desc;
 
 -- data cleaning
 SET SQL_SAFE_UPDATES = 0;

 select * from zepto
 where mrp = 0 and discountedSellingPrice = 0;
 
delete from zepto
where mrp = 0;

UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

select mrp,discountedSellingPrice from zepto;

-- Doing DATA ANALYSIS
-- 1) Find the top 10 best-value products based on the discount percentage.
SELECT distinct name,Category,mrp,discountPercent,round((mrp - (mrp * discountPercent / 100)),0) as Final_price from zepto
order by discountPercent desc
limit 10 ;

-- 2) What are the Products with High MRP but Out of Stock.
select distinct name,mrp,outOfStock
from zepto
where outOfStock = TRUE
order by mrp desc ;

-- 3) Calculate Estimated Revenue for each category
select category, format(sum(discountedSellingPrice * quantity),0) as Total_Rvenue
from zepto
group by category
order by sum(discountedSellingPrice * quantity) desc;

-- 4) Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name,mrp,discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc , discountPercent desc;

-- 5) Identify the top 5 categories offering the highest average discount percentage.
select Category,round(avg(discountPercent),2) as avg_discountPercent
from zepto
group by Category
order by avg(discountPercent) desc
limit 5;

-- 6) Find the price per gram for products above 100g and sort by best value.
select distinct name ,weightInGms,discountedSellingPrice, round((discountedSellingPrice/weightInGms),2) as price_per_gram
from zepto
where weightInGms >= 100
order by (discountedSellingPrice/weightInGms) desc;

-- 7) Group the products into categories like Low, Medium, Bulk.
select distinct Category,WeightInGms,
case
when WeightInGms < 1000 then 'Low'
when WeightInGms < 5000 then 'Medium'
else 'Bulk' end as weight_Status
from zepto;

-- 8) What is the Total Inventory Weight Per Category
select Category ,sum(WeightInGms * availableQuantity) as Inventory_Weight
from zepto
group by Category
order by sum(WeightInGms * availableQuantity) asc;








