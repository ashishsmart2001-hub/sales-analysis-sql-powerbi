-- ============================================================
-- 04_data_quality_checks.sql
-- Purpose: Validate the cleaned data and the vw_SalesDashboard view
--          by checking for duplicate keys, missing (NULL) values,
--          and orphan records (foreign keys with no matching parent).
-- Database: project
-- ============================================================

USE project;

-- ------------------------------------------------------------
-- 1. Duplicate key checks
-- ------------------------------------------------------------
SELECT OrderNumber, COUNT(*) AS Cnt
FROM sales_orders
GROUP BY OrderNumber
HAVING COUNT(*) > 1;

SELECT `Customer Index`, COUNT(*) AS Cnt
FROM customers
GROUP BY `Customer Index`
HAVING COUNT(*) > 1;

SELECT `Index`, COUNT(*) AS Cnt
FROM products
GROUP BY `Index`
HAVING COUNT(*) > 1;

SELECT `Index`, COUNT(*) AS Cnt
FROM regions
GROUP BY `Index`
HAVING COUNT(*) > 1;

-- ------------------------------------------------------------
-- 2. NULL checks on the base Sales_Orders table
-- ------------------------------------------------------------
SELECT
    SUM(CASE WHEN OrderNumber IS NULL THEN 1 ELSE 0 END)                 AS Null_OrderNumber,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END)                   AS Null_OrderDate,
    SUM(CASE WHEN `Customer Name Index` IS NULL THEN 1 ELSE 0 END)       AS Null_CustomerIndex,
    SUM(CASE WHEN `Product Description Index` IS NULL THEN 1 ELSE 0 END) AS Null_ProductIndex,
    SUM(CASE WHEN `Delivery Region Index` IS NULL THEN 1 ELSE 0 END)     AS Null_RegionIndex,
    SUM(CASE WHEN `Order Quantity` IS NULL THEN 1 ELSE 0 END)            AS Null_OrderQty,
    SUM(CASE WHEN `Unit Price` IS NULL THEN 1 ELSE 0 END)                AS Null_UnitPrice,
    SUM(CASE WHEN `Line Total` IS NULL THEN 1 ELSE 0 END)                AS Null_LineTotal,
    SUM(CASE WHEN `Total Unit Cost` IS NULL THEN 1 ELSE 0 END)           AS Null_TotalUnitCost
FROM sales_orders;

-- ------------------------------------------------------------
-- 3. NULL checks on the final dashboard view
--    (Budget2017 can legitimately be NULL for products with no
--    matching row in 2017_Budgets, since that join is a LEFT JOIN)
-- ------------------------------------------------------------
SELECT
    SUM(CASE WHEN CustomerName IS NULL THEN 1 ELSE 0 END)   AS Null_Customer,
    SUM(CASE WHEN ProductName IS NULL THEN 1 ELSE 0 END)    AS Null_Product,
    SUM(CASE WHEN RegionFullName IS NULL THEN 1 ELSE 0 END) AS Null_Region,
    SUM(CASE WHEN LineTotal IS NULL THEN 1 ELSE 0 END)      AS Null_LineTotal,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END)         AS Null_Profit,
    SUM(CASE WHEN Budget2017 IS NULL THEN 1 ELSE 0 END)     AS Null_Budget
FROM vw_SalesDashboard;

-- ------------------------------------------------------------
-- 4. Orphan record checks (foreign keys with no matching parent row)
-- ------------------------------------------------------------
SELECT COUNT(*) AS OrphanCustomers
FROM sales_orders so
LEFT JOIN customers c ON so.`Customer Name Index` = c.`Customer Index`
WHERE c.`Customer Index` IS NULL;

SELECT COUNT(*) AS OrphanProducts
FROM sales_orders so
LEFT JOIN products p ON so.`Product Description Index` = p.`Index`
WHERE p.`Index` IS NULL;

SELECT COUNT(*) AS OrphanRegions
FROM sales_orders so
LEFT JOIN regions r ON so.`Delivery Region Index` = r.`Index`
WHERE r.`Index` IS NULL;
