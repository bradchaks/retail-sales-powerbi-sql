USE RetailAnalytics;
GO

-- =========================================================
-- PROJECT: Retail Sales & Customer Insights
-- SECTION 1: OVERALL SALES KPIs
-- =========================================================

SELECT
    COUNT(DISTINCT CASE
        WHEN TransactionType = 'Standard'
        THEN InvoiceNo
    END) AS StandardInvoices,

    COUNT(DISTINCT CASE
        WHEN TransactionType = 'Cancellation'
        THEN InvoiceNo
    END) AS CancellationInvoices,

    COUNT(DISTINCT CustomerID) AS UniqueCustomers,

    COUNT(DISTINCT StockCode) AS UniqueStockCodes,

    SUM(CASE
        WHEN TransactionType = 'Standard'
             AND Quantity > 0
             AND UnitPrice > 0
        THEN TransactionValue
        ELSE 0
    END) AS GrossSalesValue,

    SUM(CASE
        WHEN TransactionType = 'Cancellation'
             AND Quantity < 0
             AND UnitPrice > 0
        THEN TransactionValue
        ELSE 0
    END) AS CancellationValue

FROM dbo.vw_RetailCleaned;


-- =========================================================
-- SECTION 2: MONTHLY SALES PERFORMANCE
-- =========================================================

SELECT
    YEAR(InvoiceDate) AS SalesYear,
    MONTH(InvoiceDate) AS SalesMonth,

    SUM(CASE
        WHEN TransactionType = 'Standard'
             AND Quantity > 0
             AND UnitPrice > 0
        THEN TransactionValue
        ELSE 0
    END) AS GrossSales,

    SUM(CASE
        WHEN TransactionType = 'Cancellation'
             AND Quantity < 0
             AND UnitPrice > 0
        THEN TransactionValue
        ELSE 0
    END) AS CancellationValue,

    COUNT(DISTINCT CASE
        WHEN TransactionType = 'Standard'
             AND Quantity > 0
             AND UnitPrice > 0
        THEN InvoiceNo
    END) AS StandardInvoices,

    COUNT(DISTINCT CASE
        WHEN TransactionType = 'Standard'
             AND Quantity > 0
             AND UnitPrice > 0
        THEN CustomerID
    END) AS UniqueCustomers

FROM dbo.vw_RetailCleaned
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate)
ORDER BY
    SalesYear,
    SalesMonth;


-- =========================================================
-- SECTION 3: TOP 10 PRODUCTS BY GROSS SALES
-- =========================================================

SELECT TOP 10
    StockCode,
    Description,
    SUM(Quantity) AS UnitsSold,
    COUNT(DISTINCT InvoiceNo) AS InvoiceCount,
    SUM(TransactionValue) AS GrossSales

FROM dbo.vw_RetailCleaned

WHERE TransactionType = 'Standard'
    AND Quantity > 0
    AND UnitPrice > 0
    AND Description IS NOT NULL
    AND StockCode <> 'M'
    AND StockCode NOT LIKE 'POST%'
    AND StockCode NOT LIKE 'AMAZON%'
    AND StockCode NOT LIKE 'BANK CHARGES%'
    AND StockCode <> 'DOT'

GROUP BY
    StockCode,
    Description

ORDER BY
    GrossSales DESC;


-- =========================================================
-- SECTION 4: CUSTOMER ACTIVE-MONTH ANALYSIS
-- Counts how many calendar months each customer purchased in.
-- This is not a formal retention or churn calculation.
-- =========================================================

WITH CustomerMonthlyActivity AS (
    SELECT DISTINCT
        CustomerID,
        YEAR(InvoiceDate) AS SalesYear,
        MONTH(InvoiceDate) AS SalesMonth

    FROM dbo.vw_RetailCleaned

    WHERE TransactionType = 'Standard'
        AND Quantity > 0
        AND UnitPrice > 0
        AND CustomerID IS NOT NULL
),

CustomerActivity AS (
    SELECT
        CustomerID,
        COUNT(*) AS ActiveMonths

    FROM CustomerMonthlyActivity

    GROUP BY CustomerID
),

ActivitySummary AS (
    SELECT
        ActiveMonths,
        COUNT(*) AS NumberOfCustomers

    FROM CustomerActivity

    GROUP BY ActiveMonths
)

SELECT
    ActiveMonths,
    NumberOfCustomers,

    CAST(
        100.0 * NumberOfCustomers
        / SUM(NumberOfCustomers) OVER ()
        AS DECIMAL(5, 2)
    ) AS PercentageOfCustomers

FROM ActivitySummary

ORDER BY ActiveMonths;