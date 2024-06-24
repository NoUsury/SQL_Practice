-- total number of products for each product category
SELECT PRODCATEGORYID, COUNT(*) as total_no FROM bike_sales.products
group by PRODCATEGORYID;

-- top 5 most expensive products.
SELECT PRODUCTID, PRICE FROM products
ORDER BY PRICE DESC
LIMIT 5;

-- all products that belong to the 'Mountain Bike' category
SELECT * FROM products p
LEFT JOIN productcategorytext pt
ON p.PRODCATEGORYID=pt.PRODCATEGORYID
WHERE SHORT_DESCR LIKE 'Mountain Bike'
;

-- total sales amount (gross) for each product category
SELECT PRODCATEGORYID, SUM((s.GROSSAMOUNT)) AS GROSS 
FROM salesorders s
LEFT JOIN products p
ON s.PARTNERID=p.SUPPLIER_PARTNERID
GROUP BY PRODCATEGORYID;

-- total gross amount for each sales order.
SELECT SALESORDERID,SUM(GROSSAMOUNT) AS total_gross_amount 
FROM salesorders
GROUP BY SALESORDERID
ORDER BY total_gross_amount DESC;

-- Trend in sales over different fiscal year periods
UPDATE salesorders2
SET FISCALYEARPERIOD = STR_TO_DATE(CONCAT(LEFT(FISCALYEARPERIOD, 4), '-', MID(FISCALYEARPERIOD, 5, 3)), '%Y-%j');

ALTER TABLE salesorders2
MODIFY COLUMN FISCALYEARPERIOD DATE;

WITH ROLLING_TOTAL AS (
SELECT YEAR(FISCALYEARPERIOD) AS `YEAR`,SUM(GROSSAMOUNT) AS total_sales 
FROM salesorders2
GROUP BY `YEAR`
ORDER BY total_sales DESC)
SELECT *, SUM(total_sales) OVER(ORDER BY total_sales DESC) AS rolling_totalsales FROM ROLLING_TOTAL;











