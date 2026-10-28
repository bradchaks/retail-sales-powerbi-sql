WITH OriginalLines AS (
    SELECT
        InvoiceNo,
        StockCode,
        CustomerID,
        Quantity,
        CAST(UnitPrice AS DECIMAL(18, 2)) AS UnitPrice,
        MIN(InvoiceDate) AS OriginalDate,
        COUNT(*) AS OriginalLineCount
    FROM dbo.OnlineRetail
    WHERE InvoiceNo NOT LIKE 'C%'
      AND Quantity > 0
      AND UnitPrice > 0
    GROUP BY
        InvoiceNo,
        StockCode,
        CustomerID,
        Quantity,
        CAST(UnitPrice AS DECIMAL(18, 2))
),
CancellationLines AS (
    SELECT
        InvoiceNo AS CancellationInvoice,
        StockCode,
        CustomerID,
        ABS(Quantity) AS Quantity,
        CAST(UnitPrice AS DECIMAL(18, 2)) AS UnitPrice,
        MIN(InvoiceDate) AS CancellationDate,
        COUNT(*) AS CancellationLineCount
    FROM dbo.OnlineRetail
    WHERE InvoiceNo LIKE 'C%'
      AND Quantity < 0
      AND UnitPrice > 0
    GROUP BY
        InvoiceNo,
        StockCode,
        CustomerID,
        ABS(Quantity),
        CAST(UnitPrice AS DECIMAL(18, 2))
),
PotentialMatches AS (
    SELECT
        O.InvoiceNo AS OriginalInvoice,
        C.CancellationInvoice,
        O.StockCode,
        O.Quantity,
        O.UnitPrice,
        O.OriginalLineCount,
        C.CancellationLineCount,
        O.OriginalDate,
        C.CancellationDate,
        O.Quantity * O.UnitPrice AS OriginalValue
    FROM OriginalLines O
    INNER JOIN CancellationLines C
        ON O.StockCode = C.StockCode
        AND O.CustomerID = C.CustomerID
        AND O.Quantity = C.Quantity
        AND O.UnitPrice = C.UnitPrice
        AND C.CancellationDate >= O.OriginalDate
)
SELECT
    COUNT(*) AS PotentialMatchingLinePairs,
    COUNT(DISTINCT OriginalInvoice) AS OriginalInvoicesMatched,
    COUNT(DISTINCT CancellationInvoice) AS CancellationInvoicesMatched,
    SUM(OriginalValue) AS PotentialMatchedValue,
    SUM(
        CASE
            WHEN OriginalLineCount = CancellationLineCount
            THEN 1 ELSE 0
        END
    ) AS PairsWithEqualLineCounts
FROM PotentialMatches;