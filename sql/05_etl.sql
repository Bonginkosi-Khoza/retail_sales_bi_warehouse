-- ==========================================================
-- ETL: Data Cleaning / Transform
-- File: 05_etl.sql
-- Purpose: Clean raw staging data according to profiling report
-- ==========================================================

-- 1️. Replacing missing descriptions with 'Unknown Product'
UPDATE stg_sales
SET Description = 'Unknown Product'
WHERE Description IS NULL
   OR TRIM(Description) = '';

-- 2️. Standardizing CustomerID (keep NULLs for guest buyers, trim spaces)
UPDATE stg_sales
SET CustomerID = TRIM(CustomerID)
WHERE CustomerID IS NOT NULL;

-- 3. Standardizing Country names (trim, capitalize first letters)
UPDATE stg_sales
SET Country = UPPER(SUBSTR(Country,1,1)) || LOWER(SUBSTR(Country,2))
WHERE Country IS NOT NULL;

-- 4️.  Standardizing InvoiceDate format (convert TEXT YYYY/MM/DD HH:MM → DATE)
-- Since SQLite stores dates as TEXT, we just trim to YYYY-MM-DD
UPDATE stg_sales
SET InvoiceDate = SUBSTR(InvoiceDate,1,10)
WHERE InvoiceDate IS NOT NULL;

-- 5️. Flagging negative quantities (returns)
-- We'll keep negative Quantity in fact table but mark them
ALTER TABLE stg_sales ADD COLUMN ReturnFlag INTEGER DEFAULT 0;
UPDATE stg_sales
SET ReturnFlag = 1
WHERE Quantity < 0;

-- 6. Removing leading/trailing spaces from StockCode
UPDATE stg_sales
SET StockCode = TRIM(StockCode)
WHERE StockCode IS NOT NULL;

--====================================================================
-- Checking for duplicated records in dim_product
SELECT 
    product_code,
    COUNT(*) AS occurrences
FROM dim_product
GROUP BY product_code
HAVING COUNT(*) > 1;

-- removing duplicated in dim_product keeping only one record per product_code
CREATE TABLE dim_prod AS
SELECT 
   MIN(product_key) AS product_key,
   product_code,
   product_description
FROM dim_product
GROUP BY product_code;

DROP TABLE dim_product;

ALTER TABLE dim_prod RENAME TO dim_product;



-- Duplicate check for dim_customer
SELECT 
    customer_id,
    COUNT(*) AS occurrences
FROM dim_customer
GROUP BY customer_id
HAVING occurrences > 1;

SELECT COUNT(*) FROM dim_customer;

