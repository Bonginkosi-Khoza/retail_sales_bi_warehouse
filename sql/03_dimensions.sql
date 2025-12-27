
-- =====================================================================================
--  DIMENSION: PRODUCT
-- ====================================================================================

DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product AS
SELECT DISTINCT
    StockCode AS product_code,
    COALESCE(NULLIF(TRIM(Description), ''), 'UNKNOWN PRODUCT') AS product_name
FROM stg_sales;
------------------null / blank description handled replaced with "UNKNOWN PRODUCT"
------------------using COALESCE= to return first non-null value

-- =====================================================================================
-- DIMENSION: CUSTOMER
-- =====================================================================================

DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer AS
SELECT DISTINCT
    CustomerID AS customer_id,
    Country AS customer_country,
    CASE
        WHEN CustomerID IS NULL THEN 'UNKNOWN CUSTOMER'
        ELSE 'VALID CUSTOMER'
    END AS customer_status
FROM stg_sales;
------------------null CustomerID handled with CASE statement to flag as UNKNOWN CUSTOMER


-- =====================================================================================
-- DIMENSION: COUNTRY
-- =====================================================================================

DROP TABLE IF EXISTS dim_country;

CREATE TABLE dim_country AS
SELECT DISTINCT
    COALESCE(NULLIF(TRIM(Country),''),'UNKNOWN') AS country_name
FROM stg_sales;
------------------null / blank country handled replaced with "UNKNOWN"

-- =====================================================================================
-- DIMENSION:   DATE
-- =====================================================================================

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date AS
WITH cleaned AS(
    SELECT
        -- converting 'YYYY/MM/DD HH:MM' → 'YYYY-MM-DD HH:MM'
        REPLACE(InvoiceDate,'/', '-') AS fixed_date
    FROM stg_sales
    WHERE InvoiceDate IS NOT NULL
)
SELECT DISTINCT 
    DATE(fixed_date) AS date_value,
    CAST(STRFTIME('%Y', fixed_date) AS INTEGER) AS year,
    CAST(STRFTIME('%m', fixed_date)AS INTEGER) AS month,
    CAST(STRFTIME('%d', fixed_date) AS INTEGER) AS day,
    STRFTIME('%Y-%m', fixed_date) AS year_month
FROM cleaned
WHERE fixed_date IS NOT NULL;
------------------converted date format and extracted year, month, day, year_month

