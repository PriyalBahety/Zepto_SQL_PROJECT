drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(8,2),
availbleQunatity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outofStock BOOLEAN,
quantity INTEGER
);

--data exploration 
-- count of rows 
SELECT COUNT(*) FROM zepto;
--sample data 
SELECT * FROM zepto
LIMIT 10;
-- null values 

SELECT * FROM zepto
WHERE name IS NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
discountedSellingPrice is NULL
OR
weightInGms IS NULL
OR
availbleQunatity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories 
SELECT DISTINCT category
FROM zepto
ORDER BY category;
-- products in stock vs out of stock 
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times 
SELECT  name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name 
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning 

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto 
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--Q.1 Find the top best-value products based on the discount Percentage 
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q.2 What are the products with high MRP Products with HIGH MRP but Out Of Stock
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;
	
-- Q.3 Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availbleQunatity) AS total_revenue 
FROM zepto
GROUP BY category
ORDER BY total_revenue;
-- Q.4 Find all products where MRP is greater than 500 and discount is less than 10%
SELECT DISTINCT name, mrp , discountPercent
FROM zepto
where mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC , discountPercent DESC;

--Q.5 Identify the top 5 categories offering highest discont
SELECT category,
ROUND(AVG(discountPercent),2)AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q.6 Find the price per gram for products above 100g and sort by best value 
SELECT DISTINCT name,weightInGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >=100
ORDER BY price_per_gram;

--Q.7 Group the products into categories like low medium and bulk 
SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;	

--Q.8 What is the total Inventory Weight Per category
SELECT category,
SUM(weightInGms * availbleQunatity ) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;











