
 -- 1. GLOBAL BEST SELLING PRODUCTS BY TOTAL REVENUE

 SELECT
    p.product_name,
    SUM(f.revenue) AS total_revenue
FROM fact_sales f  
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;
------------Top 10



-- 2. BEST PERFORMING PRODUCT PER COUNTRY BY REVENUE

SELECT 
    f.country,
    p.product_name,
    SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY f.country, p.product_name
ORDER BY f.country, revenue DESC;
------------getting all products and reveneue per country in descending order

WITH ranked AS (
    SELECT 
        country,
        product_name,
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY country ORDER BY SUM(revenue) DESC) AS rnk
    FROM fact_sales f
    JOIN dim_product p ON f.product_key = p.product_key
    GROUP BY country, product_name
)
SELECT country, product_name, total_revenue
FROM ranked WHERE rnk=1;
------------extracting best performing product per country



-- 3. MONTHLY SALES TREND (TiIME-SERIES)

SELECT 
    d.year,
    d.month,
    SUM(f.revenue) AS monthly_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_value
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
------------monthly sales trend by year and month
------------(use-cases: sales forecasting, seasonal trend analysis and business reporting)



-- 4. TOTAL REVENUE BY COUNTRY

SELECT 
    country,
    SUM(revenue) AS revenue
FROM fact_sales
GROUP BY country
ORDER BY revenue DESC;
------------total revenue by country in descending order



-- 5. MOST FREQUENT CUSTOMERS

SELECT 
    s.CustomerID,
    COUNT(*) AS purchase_count,
    SUM(s.Quantity * s.UnitPrice) AS total_spent
FROM stg_sales s
GROUP BY s.CustomerID
ORDER BY total_spent DESC
LIMIT 10;
------------top 10 most frequent customers by purchase count and total revenue