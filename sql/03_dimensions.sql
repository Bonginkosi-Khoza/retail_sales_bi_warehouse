
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
-- DIMENSION: DATE
-- =====================================================================================

