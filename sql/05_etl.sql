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



-- 6. Remove leading/trailing spaces from StockCode
UPDATE stg_sales
SET StockCode = TRIM(StockCode)
WHERE StockCode IS NOT NULL;

