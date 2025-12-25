-- ================================================
-- FACT TABLE: SALES
-- ================================================

DrOP TABLE IF EXISTS fact_sales;

CREATE TABLE factsales AS
SELECT
    d.date_value AS date_key,
    p.product_key,
    s.country AS country,
    s.Quantity,
    s.UnitPrice,
    s.Quantity * s.UnitPrice AS revenue
FROM stg_sales s
INNER JOIN dim_date d 
    ON DATE(REPLACE(SUBSTR(s.InvoiceDate,1 , 10), '/', '-')) = d.date_value
INNER JOIN dim_product p 
    ON s.StockCode = p.StockCode
WHERE s.Quantity IS NOT NULL
    AND s.UnitPrice IS NOT NULL;