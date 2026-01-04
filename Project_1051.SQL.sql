create database project_1051;

use project_1051;

CREATE TABLE ecommerce_data (
    SerialNo INT PRIMARY KEY,
    Administrative INT,
    Administrative_Duration FLOAT,
    Informational INT,
    Informational_Duration FLOAT,
    ProductRelated INT,
    ProductRelated_Duration FLOAT,
    BounceRates FLOAT,
    ExitRates FLOAT,
    PageValues FLOAT,
    SpecialDay FLOAT,
    Month VARCHAR(10),
    OperatingSystems INT,
    Browser INT,
    Region INT,
    TrafficType INT,
    VisitorType VARCHAR(20),
    Weekend BOOLEAN,
    Revenue BOOLEAN
);



-- 1
SELECT 
    COUNT(*) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS PurchasedVisitors,
    SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NotPurchasedVisitors,
    CONCAT(ROUND((SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2), '%') AS PurchasedPercentage,
    CONCAT(ROUND((SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2), '%') AS NotPurchasedPercentage
FROM ecommerce_data;

-- 2
SELECT 
    VisitorType,
    COUNT(*) AS VisitorCount,
    CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2), '%') AS Percentage
FROM ecommerce_data
WHERE Revenue = TRUE
GROUP BY VisitorType;

-- 3
SELECT 
    CASE 
        WHEN (Administrative + Informational + ProductRelated) <= 5 THEN 'Low (1-5 pages)'
        WHEN (Administrative + Informational + ProductRelated) <= 15 THEN 'Medium (6-15 pages)'
        ELSE 'High (16+ pages)'
    END AS BrowsingPattern,
    COUNT(*) AS Purchases,
    CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2), '%') AS Percentage
FROM ecommerce_data
WHERE Revenue = TRUE
GROUP BY BrowsingPattern
ORDER BY Purchases DESC;

-- 4
SELECT 
    TrafficType,
    COUNT(*) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS Purchases,
    SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NonPurchases,
    CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS ConversionRate,
    CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2), '%') AS TrafficShare
FROM ecommerce_data
GROUP BY TrafficType
ORDER BY ConversionRate;

-- 5
SELECT 
    ProductRelated AS ProductPageNo,
    COUNT(*) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS PurchasedCount,
    SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NotPurchasedCount,
    CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS PurchaseRate,
    ROUND(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS PurchaseRateNumeric
FROM ecommerce_data
WHERE ProductRelated > 0 
GROUP BY ProductRelated
HAVING COUNT(*) >= 5  
ORDER BY PurchaseRateNumeric DESC;

-- 6
SELECT 
    TrafficType,
    COUNT(*) AS TotalVisits,
    SUM(ProductRelated) AS TotalProductPagesVisited
FROM ecommerce_data
WHERE TrafficType IN (12, 15, 17, 18)
GROUP BY TrafficType
ORDER BY TrafficType;

-- 7
SELECT 
    CASE 
        WHEN Revenue = TRUE THEN 'Purchased'
        ELSE 'Not Purchased'
    END AS PurchaseStatus,
    ROUND(AVG(Administrative), 2) AS AvgAdminPages,
    ROUND(AVG(Informational), 2) AS AvgInfoPages,
    ROUND(AVG(ProductRelated), 2) AS AvgProductPages,
    ROUND(AVG(Administrative + Informational + ProductRelated), 2) AS AvgTotalPages,
    COUNT(*) AS TotalVisitors
FROM ecommerce_data
GROUP BY Revenue
ORDER BY PurchaseStatus DESC;

-- 8
SELECT 
    CASE 
        WHEN Revenue = TRUE THEN 'Purchased'
        ELSE 'Not Purchased'
    END AS PurchaseStatus,
    
    -- All in Minutes
    ROUND(AVG(Administrative_Duration) / 60, 1) AS AvgAdminMinutes,
    ROUND(AVG(Informational_Duration) / 60, 1) AS AvgInfoMinutes,
    ROUND(AVG(ProductRelated_Duration) / 60, 1) AS AvgProductMinutes,
    ROUND(AVG(Administrative_Duration + Informational_Duration + ProductRelated_Duration) / 60, 1) AS AvgTotalMinutes,
    
    COUNT(*) AS TotalVisitors
FROM ecommerce_data
GROUP BY Revenue
ORDER BY PurchaseStatus DESC;

-- 9
SELECT 
    'All Selected Pages' AS Description,
    COUNT(*) AS TotalVisitors,
    ROUND(AVG(Informational_Duration) / 60, 1) AS AvgInfoPagesDurationMin,
    ROUND(AVG(Administrative_Duration) / 60, 1) AS AvgAdminPagesDurationMin,
    ROUND(AVG(ProductRelated_Duration) / 60, 1) AS AvgProductPagesDurationMin,
    ROUND(AVG(Informational_Duration + Administrative_Duration + ProductRelated_Duration) / 60, 1) AS AvgTotalDurationMin,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS PurchasedCount,
    CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1), '%') AS PurchaseRate
FROM ecommerce_data
WHERE ProductRelated IN (
    32, 127, 159, 64, 57, 70, 89, 69, 50, 98, 
    30, 63, 56, 85, 77, 93, 104, 117, 133, 58, 
    60, 111, 53, 59, 48, 76, 110, 37, 44, 54, 
    51, 45, 21, 66, 73, 29, 22, 34, 27, 31, 
    28, 49, 67, 84, 96, 87, 130, 119, 134, 139, 
    33, 62, 42, 79, 19, 43, 38, 41, 35, 26, 
    23, 24, 71, 154, 47, 17, 46, 90, 39, 20, 
    14, 113, 150, 52, 74, 13, 10, 15, 72, 16, 
    18, 25, 86, 140, 112, 126, 40, 55, 88, 12, 
    61, 68, 65, 36, 11, 8, 94, 9, 102, 7, 
    78, 97, 6, 91, 3, 5, 4, 2, 1
);

-- 10
SELECT 
    'New Selected Pages' AS Description,
    COUNT(*) AS TotalVisitors,
    ROUND(AVG(Informational_Duration) / 60, 1) AS AvgInfoPagesDurationMin,
    ROUND(AVG(Administrative_Duration) / 60, 1) AS AvgAdminPagesDurationMin,
    ROUND(AVG(ProductRelated_Duration) / 60, 1) AS AvgProductPagesDurationMin,
    ROUND(AVG(Informational_Duration + Administrative_Duration + ProductRelated_Duration) / 60, 1) AS AvgTotalDurationMin,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS PurchasedCount,
    CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1), '%') AS PurchaseRate
FROM ecommerce_data
WHERE ProductRelated IN (
    155, 171, 145, 132, 118, 152, 137, 115, 120, 101, 
    149, 124, 75, 157, 109, 107, 83, 162, 95, 116, 
    106, 82, 122, 114, 99, 146, 81, 80, 131, 108, 
    129, 125, 92, 100
);

-- 11
SELECT 
    'Selected Pages Group' AS Description,
    COUNT(*) AS TotalVisitors,
    ROUND(AVG(Informational_Duration) / 60, 1) AS AvgInfoPagesDurationMin,
    ROUND(AVG(Administrative_Duration) / 60, 1) AS AvgAdminPagesDurationMin,
    ROUND(AVG(ProductRelated_Duration) / 60, 1) AS AvgProductPagesDurationMin,
    ROUND(AVG(Informational_Duration + Administrative_Duration + ProductRelated_Duration) / 60, 1) AS AvgTotalDurationMin,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS PurchasedCount,
    CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1), '%') AS PurchaseRate
FROM ecommerce_data
WHERE ProductRelated IN (103, 141, 128, 105, 151);

-- 12
SELECT 
    'Purchasers' AS VisitorType,
    COUNT(*) AS NumberOfVisitors,
    ROUND(AVG(BounceRates), 4) AS AvgBounceRate,
    ROUND(MIN(BounceRates), 4) AS MinBounceRate,
    ROUND(MAX(BounceRates), 4) AS MaxBounceRate,
    ROUND(STDDEV(BounceRates), 4) AS StdDevBounceRate
FROM ecommerce_data
WHERE Revenue = TRUE

UNION ALL

SELECT 
    'Non-Purchasers' AS VisitorType,
    COUNT(*) AS NumberOfVisitors,
    ROUND(AVG(BounceRates), 4) AS AvgBounceRate,
    ROUND(MIN(BounceRates), 4) AS MinBounceRate,
    ROUND(MAX(BounceRates), 4) AS MaxBounceRate,
    ROUND(STDDEV(BounceRates), 4) AS StdDevBounceRate
FROM ecommerce_data
WHERE Revenue = FALSE;

-- 13
WITH VisitorBreakdown AS (
    SELECT 
        CASE 
            WHEN Weekend = TRUE THEN 'Weekend Visitors'
            WHEN SpecialDay > 0 THEN 'Special Day Visitors'
            ELSE 'Normal Day Visitors'
        END AS DayType,
        Revenue,
        COUNT(*) AS VisitorCount
    FROM ecommerce_data
    GROUP BY 
        CASE 
            WHEN Weekend = TRUE THEN 'Weekend Visitors'
            WHEN SpecialDay > 0 THEN 'Special Day Visitors'
            ELSE 'Normal Day Visitors'
        END,
        Revenue
)
SELECT 
    DayType,
    SUM(VisitorCount) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN VisitorCount ELSE 0 END) AS Purchasers,
    SUM(CASE WHEN Revenue = FALSE THEN VisitorCount ELSE 0 END) AS NonPurchasers,
    CONCAT(ROUND((SUM(CASE WHEN Revenue = TRUE THEN VisitorCount ELSE 0 END) * 100.0 / NULLIF(SUM(VisitorCount), 0)), 2), '%') AS PurchaseRate
FROM VisitorBreakdown
GROUP BY DayType
ORDER BY 
    CASE DayType
        WHEN 'Weekend Visitors' THEN 1
        WHEN 'Special Day Visitors' THEN 2
        WHEN 'Normal Day Visitors' THEN 3
    END;

-- 14
SELECT 
    Month,
    COUNT(*) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS Purchasers,
    SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NonPurchasers,
    CONCAT(ROUND((SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0)), 2), '%') AS PurchaseRate
FROM ecommerce_data
GROUP BY Month
ORDER BY 
    CASE Month
        WHEN 'Jan' THEN 1
        WHEN 'Feb' THEN 2
        WHEN 'Mar' THEN 3
        WHEN 'Apr' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'Jul' THEN 7
        WHEN 'Aug' THEN 8
        WHEN 'Sep' THEN 9
        WHEN 'Oct' THEN 10
        WHEN 'Nov' THEN 11
        WHEN 'Dec' THEN 12
        ELSE 13
    END;

-- 15
SELECT 
    OperatingSystems AS OS,
    COUNT(*) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS Purchasers,
    SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NonPurchasers,
    CONCAT(ROUND((SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0)), 2), '%') AS PurchaseRate
FROM ecommerce_data
GROUP BY OperatingSystems
ORDER BY TotalVisitors DESC;

-- 16
SELECT 
    Browser,
    COUNT(*) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS Purchasers,
    SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NonPurchasers,
    CONCAT(ROUND((SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0)), 2), '%') AS PurchaseRate
FROM ecommerce_data
GROUP BY Browser
ORDER BY PurchaseRate desc;

-- 17
SELECT 
    Region,
    COUNT(*) AS TotalVisitors,
    SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS Purchasers,
    SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NonPurchasers,
    CONCAT(ROUND((SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0)), 2), '%') AS PurchaseRate
FROM ecommerce_data
GROUP BY Region
ORDER BY TotalVisitors DESC;

-- 18
-- Non-Purchasers Exit Analysis
SELECT 'Total Non-Purchasers' AS Metric, 
       CONCAT(COUNT(*), '') AS Value
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Exit from Product Pages (%)',
       CONCAT(ROUND(SUM(CASE WHEN ProductRelated >= Informational AND ProductRelated >= Administrative THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%')
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Exit from Info Pages (%)',
       CONCAT(ROUND(SUM(CASE WHEN Informational >= ProductRelated AND Informational >= Administrative THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%')
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Exit from Admin Pages (%)',
       CONCAT(ROUND(SUM(CASE WHEN Administrative >= ProductRelated AND Administrative >= Informational THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%')
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Average Product Pages Visited',
       CONCAT(ROUND(AVG(ProductRelated), 2), ' pages')
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Average Info Pages Visited',
       CONCAT(ROUND(AVG(Informational), 2), ' pages')
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Average Admin Pages Visited',
       CONCAT(ROUND(AVG(Administrative), 2), ' pages')
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Average Exit Rate',
       CONCAT(ROUND(AVG(ExitRates), 4), '')
FROM ecommerce_data
WHERE Revenue = FALSE

UNION ALL

SELECT 'Average Bounce Rate',
       CONCAT(ROUND(AVG(BounceRates), 4), '')
FROM ecommerce_data
WHERE Revenue = FALSE;

-- Non-Purchasers: Detailed journey patterns
SELECT 
    JourneyPattern,
    COUNT(*) AS NonPurchaserCount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Percentage,
    ROUND(AVG(ExitRates), 4) AS AvgExitRate,
    ROUND(AVG(BounceRates), 4) AS AvgBounceRate
FROM (
    SELECT 
        CASE 
            WHEN ProductRelated > 0 AND Informational = 0 AND Administrative = 0 THEN 'Only Product Pages → No Purchase'
            WHEN ProductRelated = 0 AND Informational > 0 AND Administrative = 0 THEN 'Only Info Pages → No Purchase'
            WHEN ProductRelated = 0 AND Informational = 0 AND Administrative > 0 THEN 'Only Admin Pages → No Purchase'
            WHEN ProductRelated > 0 AND Informational > 0 AND Administrative = 0 THEN 'Product + Info Pages → No Purchase'
            WHEN ProductRelated > 0 AND Informational = 0 AND Administrative > 0 THEN 'Product + Admin Pages → No Purchase'
            WHEN ProductRelated = 0 AND Informational > 0 AND Administrative > 0 THEN 'Info + Admin Pages → No Purchase'
            WHEN ProductRelated > 0 AND Informational > 0 AND Administrative > 0 THEN 'All Page Types → No Purchase'
            ELSE 'No Pages Visited → No Purchase'
        END AS JourneyPattern,
        ExitRates,
        BounceRates
    FROM ecommerce_data
    WHERE Revenue = FALSE
) AS patterns
GROUP BY JourneyPattern
ORDER BY NonPurchaserCount DESC;

-- Comparison: Purchasers vs Non-Purchasers Exit Patterns
SELECT 'Total Visitors' AS Metric, 
       SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END) AS Purchasers,
       SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END) AS NonPurchasers
FROM ecommerce_data

UNION ALL

SELECT 'Average Exit Rate',
       CONCAT(ROUND(AVG(CASE WHEN Revenue = TRUE THEN ExitRates END), 4), ''),
       CONCAT(ROUND(AVG(CASE WHEN Revenue = FALSE THEN ExitRates END), 4), '')
FROM ecommerce_data

UNION ALL

SELECT 'Exit from Product Pages (%)',
       CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE AND ProductRelated >= Informational AND ProductRelated >= Administrative THEN 1 ELSE 0 END) * 100.0 / 
                    NULLIF(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END), 0), 2), '%'),
       CONCAT(ROUND(SUM(CASE WHEN Revenue = FALSE AND ProductRelated >= Informational AND ProductRelated >= Administrative THEN 1 ELSE 0 END) * 100.0 / 
                    NULLIF(SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END), 0), 2), '%')
FROM ecommerce_data

UNION ALL

SELECT 'Exit from Info Pages (%)',
       CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE AND Informational >= ProductRelated AND Informational >= Administrative THEN 1 ELSE 0 END) * 100.0 / 
                    NULLIF(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END), 0), 2), '%'),
       CONCAT(ROUND(SUM(CASE WHEN Revenue = FALSE AND Informational >= ProductRelated AND Informational >= Administrative THEN 1 ELSE 0 END) * 100.0 / 
                    NULLIF(SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END), 0), 2), '%')
FROM ecommerce_data

UNION ALL

SELECT 'Exit from Admin Pages (%)',
       CONCAT(ROUND(SUM(CASE WHEN Revenue = TRUE AND Administrative >= ProductRelated AND Administrative >= Informational THEN 1 ELSE 0 END) * 100.0 / 
                    NULLIF(SUM(CASE WHEN Revenue = TRUE THEN 1 ELSE 0 END), 0), 2), '%'),
       CONCAT(ROUND(SUM(CASE WHEN Revenue = FALSE AND Administrative >= ProductRelated AND Administrative >= Informational THEN 1 ELSE 0 END) * 100.0 / 
                    NULLIF(SUM(CASE WHEN Revenue = FALSE THEN 1 ELSE 0 END), 0), 2), '%')
FROM ecommerce_data;