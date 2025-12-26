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
