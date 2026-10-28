USE RetailAnalytics;
GO

-- =========================================================
-- PROJECT: Retail Sales & Customer Insights
-- SECTION 1: DATASET OVERVIEW
-- PURPOSE: Understand dataset size, coverage and structure
-- =========================================================

SELECT
    COUNT(*) AS TotalRows,
    MIN(InvoiceDate) AS FirstTransactionDate,
    MAX(InvoiceDate) AS LastTransactionDate,
    COUNT(DISTINCT InvoiceNo) AS DistinctInvoices,
    COUNT(DISTINCT CustomerID) AS IdentifiableCustomers,
    COUNT(DISTINCT StockCode) AS DistinctStockCodes
FROM dbo.OnlineRetail;


-- =========================================================
-- SECTION 2: MISSING DATA
-- PURPOSE: Identify missing values requiring investigation
-- =========================================================

SELECT
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END)
        AS MissingDescriptions,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END)
        AS MissingCustomerIDs,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END)
        AS MissingUnitPrices
FROM dbo.OnlineRetail;


-- =========================================================
-- SECTION 3: TRANSACTION TYPES
-- PURPOSE: Compare standard and cancellation transactions
-- =========================================================

SELECT
    CASE
        WHEN InvoiceNo LIKE 'C%' THEN 'Cancellation'
        ELSE 'Standard'
    END AS TransactionType,
    COUNT(*) AS TransactionRows,
    SUM(Quantity) AS TotalQuantity
FROM dbo.OnlineRetail
GROUP BY
    CASE
        WHEN InvoiceNo LIKE 'C%' THEN 'Cancellation'
        ELSE 'Standard'
    END;