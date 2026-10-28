# Retail Sales & Customer Insights

## Project Overview

This project analyses online retail transaction data using SQL Server and Power BI to uncover sales trends, product performance, customer purchasing behaviour, and data quality issues.

The aim is to transform raw transactional data into meaningful business insights through SQL-based analysis and an interactive Power BI dashboard.

## Tools & Technologies

- **SQL Server & SSMS** — Data exploration, cleaning, quality checks and analytical queries.
- **Microsoft Power BI** — Interactive dashboard development and data visualisation.
- **DAX** — Measures and calculated tables for sales KPIs and customer analysis.
- **Power Query** — Data preparation and transformation.

## Dataset

The project uses the Online Retail dataset, covering transactions from December 2010 to December 2011.

The dataset contains 541,909 transaction rows, including invoice references, product descriptions, quantities, transaction dates, unit prices, customer IDs and countries.

The original dataset is not included in this repository. Please obtain it from the original source before reproducing the analysis.

## Project Workflow

### 1. Data Exploration & Quality Assessment
- Examined transaction volumes, date coverage and distinct products, invoices and customers.
- Identified missing customer IDs and product descriptions.
- Investigated cancellation transactions and unusual data patterns.
- Assessed potential duplicate records without automatically deleting them.

### 2. SQL Analysis
- Developed a cleaned analytical view, `dbo.vw_RetailCleaned`.
- Calculated gross transaction value and cancellation value.
- Analysed monthly sales performance.
- Ranked products by gross sales.
- Examined how many calendar months identifiable customers made purchases.

### 3. Power BI Dashboard
Built an interactive dashboard featuring:
- Gross sales and customer KPIs.
- Monthly gross sales trends.
- Top 10 products by gross sales.
- Top 10 countries by gross sales.
- One-time versus repeat customer analysis.
- Year-month and country slicers.

## Key Findings

- **541,909 transaction rows** were present in the original dataset.
- **£10.67 million** in gross transaction value was recorded under the project's standard-transaction definition.
- **£896,812.49 in negative cancellation transaction value** was identified.
- **£9.77 million** was the resulting net transaction value when gross sales and cancellation values were combined.
- **November 2011** was the strongest complete month in the analysed period, with gross sales of approximately £1.51 million.
- **37.67% of customers included in the active-month analysis** purchased in only one calendar month.
- Missing customer IDs affected approximately 24.9% of all transaction rows.

## Data Quality & Analytical Considerations

- Missing customer IDs were retained for overall transaction analysis but excluded from customer-level analysis where identification was required.
- December 2011 contains data only through 9 December, so it should not be compared directly with complete months.
- Cancellation values are reported separately to make their impact visible.
- Gross and net transaction values are analytical measures, not audited revenue figures.
- Potential duplicate records and unusual transactions were investigated but not automatically removed without sufficient evidence.

## Repository Structure

```text
Retail-Sales-PowerBI-SQL/
├── SQL/
│   ├── retail_analysis.sql
│   ├── data_quality_analysis.sql
│   └── retail_sales_analysis.sql
├── PowerBI/
│   ├── Retail_Sales_Customer_Insights.pbix
│   └── dashboard_screenshot.png
└── README.md
```

## Skills Demonstrated

- SQL querying and aggregation
- Data quality assessment
- Analytical view creation
- Business KPI development
- DAX measures and calculated tables
- Data visualisation and dashboard design
- Customer purchasing behaviour analysis
- Translating transaction data into business insights

## Conclusion

This project demonstrates an end-to-end analytical workflow, from exploring and assessing raw transactional data to producing SQL analysis and an interactive Power BI dashboard. It highlights the importance of data quality, transparent metric definitions and clear business communication.