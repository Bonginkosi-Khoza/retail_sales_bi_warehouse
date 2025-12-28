
-- =====================================
-- Fact table creation: fact_sales
-- =====================================

DROP TABLE IF EXISTS fact_sales;

-- CREATing fact table with surrogate key
CREATE TABLE fact_sales (
    fact_key INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id TEXT,
    date_key INTEGER,
    customer_key INTEGER,
    product_key INTEGER,
    country_name TEXT,
    Quantity INTEGER,
    UnitPrice REAL,
    total_price REAL
);

-- INSERTing data
INSERT INTO fact_sales (invoice_id, date_key, customer_key, product_key, country_name, Quantity, UnitPrice, total_price)
SELECT
    s.InvoiceNo AS invoice_id,
    d.date_key,
    c.customer_key,
    p.product_key,
    co.country_name,
    s.Quantity,
    s.UnitPrice,
    (s.Quantity * s.UnitPrice) AS total_price
FROM stg_sales s
LEFT JOIN dim_date d
    ON SUBSTR(s.InvoiceDate,1,10) = d.date_value
LEFT JOIN dim_customer c
    ON s.CustomerID = c.customer_id
LEFT JOIN dim_product p
    ON s.StockCode = p.product_code
LEFT JOIN dim_country co
    ON s.Country = co.country_name;

