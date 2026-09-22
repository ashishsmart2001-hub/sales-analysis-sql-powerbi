-- ============================================================
-- 03_view_creation.sql
-- Purpose: Build a single analytical view (vw_SalesDashboard) that
--          joins Sales_Orders with Customers, Products, Regions and
--          2017_Budgets, and adds calculated fields (Profit, Profit
--          Margin %, Budget vs Actual). This view is the data
--          source for the Power BI dashboard.
-- Database: project
-- ============================================================

USE project;

DROP VIEW IF EXISTS vw_SalesDashboard;

CREATE VIEW vw_SalesDashboard AS
SELECT
    so.OrderNumber,
    CAST(so.OrderDate AS DATE)                     AS OrderDate,
    YEAR(CAST(so.OrderDate AS DATE))                AS OrderYear,
    MONTH(CAST(so.OrderDate AS DATE))               AS OrderMonthNum,
    MONTHNAME(CAST(so.OrderDate AS DATE))           AS OrderMonthName,

    c.`Customer Names`   AS CustomerName,
    p.`Product Name`     AS ProductName,
    r.City,
    r.Country,
    r.`Full Name`        AS RegionFullName,

    so.Channel,
    so.`Currency Code`   AS CurrencyCode,
    so.`Warehouse Code`  AS WarehouseCode,
    CAST(so.`Order Quantity` AS UNSIGNED)           AS OrderQuantity,
    CAST(so.`Unit Price` AS DECIMAL(18,4))          AS UnitPrice,
    CAST(so.`Line Total` AS DECIMAL(18,2))          AS LineTotal,
    CAST(so.`Total Unit Cost` AS DECIMAL(18,4))     AS TotalUnitCost,

    -- Calculated metrics
    (CAST(so.`Order Quantity` AS UNSIGNED) * CAST(so.`Total Unit Cost` AS DECIMAL(18,4)))
        AS TotalCost,

    (CAST(so.`Line Total` AS DECIMAL(18,2))
        - (CAST(so.`Order Quantity` AS UNSIGNED) * CAST(so.`Total Unit Cost` AS DECIMAL(18,4))))
        AS Profit,

    ROUND(
        (CAST(so.`Line Total` AS DECIMAL(18,2))
            - (CAST(so.`Order Quantity` AS UNSIGNED) * CAST(so.`Total Unit Cost` AS DECIMAL(18,4))))
        / NULLIF(CAST(so.`Line Total` AS DECIMAL(18,2)), 0) * 100
    , 2) AS ProfitMarginPercent,

    CAST(b.`2017 Budgets` AS DECIMAL(18,2))         AS Budget2017,
    (CAST(so.`Line Total` AS DECIMAL(18,2)) - CAST(b.`2017 Budgets` AS DECIMAL(18,2)))
        AS BudgetVsActual

FROM sales_orders so
JOIN customers c    ON so.`Customer Name Index` = c.`Customer Index`
JOIN products  p    ON so.`Product Description Index` = p.`Index`
JOIN regions   r    ON so.`Delivery Region Index` = r.`Index`
LEFT JOIN `2017_budgets` b ON so.`Product Description Index` = b.`Product Index`;

-- ------------------------------------------------------------
-- Quick verification of the view
-- ------------------------------------------------------------
SELECT COUNT(*) AS TotalRows FROM vw_SalesDashboard;                 -- expect 10684

SELECT SUM(LineTotal) AS TotalSales, SUM(Profit) AS TotalProfit
FROM vw_SalesDashboard;
