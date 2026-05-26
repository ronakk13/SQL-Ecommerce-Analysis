-- ===================================================
-- E-commerce Sales SQL Analysis Project
-- Tools Used: MySQL
-- Concepts Used:
-- Joins, CTEs, Window Functions, Aggregations,
-- Profitability Analysis, Business Insights
-- ===================================================



CREATE DATABASE ECommerce_Sales_Analysis;
USE ECommerce_Sales_Analysis;


-- ===================================================
-- Region Wise Sales & Profit Analysis
-- ===================================================
SELECT 
      c.region AS region,
      round(SUM(o.sales),2) AS sales,
      round(SUM(o.profit),2) AS profit , 
      ROUND((SUM(o.profit)/SUM(o.sales))*100,2) AS profit_margin
FROM customers c JOIN orders o
	on c.customer_id = o.customer_id
GROUP BY region;

-- Insights
-- East and West regions contribute the highest overall sales and profit,
-- indicating strong market performance and business stability in these regions.



-- ===================================================
-- TOP 10 States by Sales
-- ===================================================
SELECT 
		c.state AS states , 
        ROUND(SUM(o.sales),2) AS sales , 
        ROUND(SUM(o.profit),2) AS profit,
        ROUND((SUM(o.profit)/SUM(o.sales))*100,2) AS profit_margin
FROM customers c JOIN orders o
	on c.customer_id = o.customer_id
GROUP BY states
ORDER BY sales DESC
LIMIT 10;

-- Insights
-- Despite strong sales performance, North Carolina remains loss-making,
-- highlighting opportunities for pricing optimization and cost-efficient marketing strategies.



-- ===================================================
-- Category Wise Sales & Profit
-- ===================================================
SELECT 
		p.category AS category , 
        ROUND(SUM(o.sales),2) AS sales , 
        ROUND(SUM(o.profit),2) AS profit,
		ROUND((SUM(o.profit)/SUM(o.sales))*100,2) AS profit_margin
FROM products p JOIN orders o
	on p.product_id = o.product_id
GROUP BY category;

-- Insights 
-- Furniture category generates the highest sales revenue but delivers significantly lower profit margins compared to other categories,
-- indicating the need for pricing optimization, discount control, and cost reduction strategies.


-- ===================================================
-- MONTHLY SALES TRENDS & GROWTH
-- ===================================================
WITH monthly_sales AS
(SELECT 
	DATE_FORMAT(order_date , '%Y-%m') AS year_months ,
	ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY DATE_FORMAT(order_date , '%Y-%m')
) , sales_month AS
(SELECT 
	year_months , 
	total_sales AS current_month_sales,
    LAG(total_sales) OVER(ORDER BY year_months) AS prev_month_sales
FROM monthly_sales)

SELECT 
	year_months,
    current_month_sales,
    prev_month_sales,
    ROUND(((current_month_sales-prev_month_sales)/prev_month_sales)*100,2) AS growth_percentage
FROM sales_month;
    
-- Insights

-- March, September, and November are peak sales months,
-- emphasizing the importance of maintaining sufficient inventory before high-demand periods.

-- Other months show fluctuating sales trends, creating opportunities for strategic discount
-- and marketing campaigns to stabilize revenue growth.


-- ===================================================
-- Top 5 Customers by Sales
-- ===================================================
WITH customer_sales AS 
(SELECT 
	c.customer_id AS customer_id,
    c.customer_name AS customer_name,
    ROUND(SUM(o.sales),2) AS sales
FROM orders o  LEFT JOIN customers c
	ON o.customer_id = c.customer_id
GROUP BY customer_id , customer_name)

SELECT 
	customer_id ,
	customer_name,
	sales
FROM customer_sales
ORDER BY sales DESC
LIMIT 5;



-- ===================================================
-- LOSS Making States ans Sub-Category
-- ===================================================
SELECT 
	c.state AS states,
    ROUND(SUM(o.sales),2) AS sales,
    ROUND(SUM(o.profit),2) AS profit
FROM customers c LEFT JOIN orders o 
	ON c.customer_id = o.customer_id
GROUP BY states
HAVING ROUND(SUM(o.profit),2)<0;

SELECT 
	p.sub_category AS sub_category,
    ROUND(SUM(o.sales),2) AS sales,
    ROUND(SUM(o.profit),2) AS profit
FROM products p  LEFT JOIN orders o 
	ON p.product_id = o.product_id
GROUP BY sub_category
HAVING ROUND(SUM(o.profit),2)<0;



-- ===================================================
-- Final Business Recommendations
-- ===================================================

-- Improve pricing and discount strategies for loss-making categories.
-- Optimize Standard Class shipping efficiency to reduce delivery delays.
-- Increase inventory before seasonal peak periods.
-- Focus marketing investments in high-performing regions.
        
