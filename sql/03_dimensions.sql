-- =====================================================================================
-- DIMENSION: DATE
-- =====================================================================================

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date AS 
SELECT DISTINCT
    DATE(REPLACE(SUBSTR(InvoiceDate, 1, 10), '/', '-')) AS date_value, 
    CAST(STRFTIME('%Y', REPLACE(SUBSTR(InvoiceDate, 1, 10), '/', '-')) AS INTEGER) AS year,
    CAST(STRFTIME('%m', REPLACE(SUBSTR(InvoiceDate, 1, 10), '/', '-'))AS INTEGER) AS month,
    CAST(STRFTIME('%d', REPLACE(SUBSTR(InvoiceDate, 1, 10), '/', '-')) AS INTEGER) AS day,
    STRFTIME('%Y-%m', REPLACE(SUBSTR(InvoiceDate, 1, 10), '/', '-')) AS year_month
FROM stg_sales
WHERE InvoiceDate IS NOT NULL;

-- =======
--  DIMENSION: PRODUCT

DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY StockCode) AS product_key,
    StockCode,
    COALESCE(TRIM(UPPER(Description)), 'UKNOWN PRODUCT') AS product_name
FROM (
    SELECT DISTINCT StockCode, Description
    FROM stg_sales
    WHERE StockCode IS NOT NULL
    GROUP BY StockCode
);