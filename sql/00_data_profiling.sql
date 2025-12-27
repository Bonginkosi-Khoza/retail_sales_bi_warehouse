-- 00_data_profiling.sql
-- Purpose: Running data quality checks on staging dataset and document issues found.
-- To ensure reproducibility for auditors, reviewer and portfolio demonstration.

-- 1. Total row count
SELECT COUNT(*) AS total_rows FROM stg_sales;

-- 2. Missing CustomerID
SELECT COUNT(*) AS missing_customer_id
FROM stg_sales
WHERE CustomerID IS NULL;

-- 3. Sample of missing CustomerID rows
SELECT *
FROM stg_sales
WHERE CustomerID IS NULL
LIMIT 10;

-- 4. Missing product descriptions
SELECT COUNT(*) AS missing_description
FROM stg_sales
WHERE Description IS NULL OR TRIM(Description) = '';

-- 5. Missing or blank country entries
SELECT COUNT(*) AS missing_country
FROM stg_sales
WHERE Country IS NULL OR TRIM(Country) = '';

-- 6. Negative or zero quantities (returns)
SELECT COUNT(*) AS negative_or_zero_qty
FROM stg_sales
WHERE Quantity <= 0;

SELECT *
FROM stg_sales
WHERE Quantity <= 0
LIMIT 10;

-- 7. Price range
SELECT MIN(UnitPrice) AS min_price, MAX(UnitPrice) AS max_price
FROM stg_sales;

-- 8. Detect InvoiceDate formatting problems
SELECT typeof(InvoiceDate) AS datatype, COUNT(*) AS rows
FROM stg_sales
GROUP BY typeof(InvoiceDate);
