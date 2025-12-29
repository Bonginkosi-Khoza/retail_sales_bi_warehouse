# Data Quality Assessment Report

Dataset: Retail Sales (541,910 rows)

## Observations Summary

| Issue | Count | Notes |
|---|---|---|
| Total rows | 541,910 | Baseline dataset size |
| Missing CustomerID | 53,641 | Many purchases without customer records → needs handling |
| Missing Description | 1,454 | We must replace with 'Unknown Product' |
| Missing Country | 0, but 1 labeled 'Unspecified' | Standardize later |
| InvoiceDate stored as TEXT | Yes | Must convert to DATE format during ETL |
| Negative quantities | Present (returns/refunds) | Should load into Fact table but flagged |
| UnitPrice range | 0.0 → 99.96 | Outliers → detect later |

## Decisions
- Replace missing descriptions with `'Unknown Product'`
- Keep NULL CustomerID (represent guest buyers)
- Convert InvoiceDate → DATE format on load
- Negative quantities kept, flagged as returns
- Standardize text data & trim whitespace

### Issue: Fact table row count higher than staging

**Observed behavior:**  
- stg_sales rows: 541,910  
- fact_sales rows: 794,950  
- Unexpected increase ~250k rows.

**Possible cause:**  
- Duplicate rows in dimension tables caused by non-unique keys.  
- Joins in fact insert multiplied rows.

**Date reported:** 2025-12-28  
**Reporter:** Bonginkosi Khoza

## Product Dimension Duplicate Issue
- During validation, 1321 duplicate product entries were found in `dim_product`.
- Cause: Staging load created multiple rows for the same product_code.
- Risk: Leads to inflated `fact_sales` row count during joins.
- Fix Approach: Keep first occurrence per product_code, deduplicate dimension.

- Fix Applied: Deduplicated dim_product by recreating the table keeping MIN(product_key) per product_code.
- Result: Surrogate keys preserved, duplicate records removed.
- Validation: Expect dim_product count to reduce from 5749 to (5749 - 1321).
 