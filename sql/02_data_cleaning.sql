-- ============================================================
-- 02_data_cleaning.sql
-- Purpose: Convert OrderDate from text to a proper DATE type, and
--          re-clean numeric columns (Unit Price, Line Total,
--          Total Unit Cost, 2017 Budgets) that contained comma
--          separators, using temporary staging tables.
-- Database: project
-- ============================================================

USE project;

-- ------------------------------------------------------------
-- 1. Convert OrderDate (text, e.g. "01/15/2017") to a real DATE column
-- ------------------------------------------------------------
ALTER TABLE sales_orders
ADD COLUMN OrderDate_new DATE;

UPDATE sales_orders
SET OrderDate_new = STR_TO_DATE(OrderDate, '%m/%d/%Y');

-- Sanity check: make sure no rows failed to convert
SELECT COUNT(*) AS FailedRows
FROM sales_orders
WHERE OrderDate_new IS NULL;

ALTER TABLE sales_orders
DROP COLUMN OrderDate;

ALTER TABLE sales_orders
CHANGE OrderDate_new OrderDate DATE;

-- ------------------------------------------------------------
-- 2. Re-clean Sales_Orders numeric columns via a staging table
--    (source values contained comma thousand-separators, e.g. "1,234.50")
-- ------------------------------------------------------------
CREATE TABLE sales_orders_staging (
    OrderNumber       VARCHAR(20),
    OrderDate         VARCHAR(30),
    CustomerIndex     VARCHAR(20),
    Channels          VARCHAR(50),
    CurrencyCode      VARCHAR(10),
    WarehouseCode     VARCHAR(20),
    RegionIndex       VARCHAR(20),
    ProductIndex      VARCHAR(20),
    OrderQuantity     VARCHAR(20),
    UnitPrice         VARCHAR(30),
    LineTotal         VARCHAR(30),
    TotalUnitCost     VARCHAR(30)
);

-- NOTE: sales_orders_staging is populated by importing the raw CSV
-- (see /data/Sales_Orders.csv) before running the UPDATE below.

UPDATE sales_orders so
JOIN sales_orders_staging st ON so.OrderNumber = st.OrderNumber
SET
    so.`Unit Price`      = CAST(REPLACE(st.UnitPrice, ',', '')     AS DECIMAL(18,4)),
    so.`Line Total`      = CAST(REPLACE(st.LineTotal, ',', '')     AS DECIMAL(18,2)),
    so.`Total Unit Cost` = CAST(REPLACE(st.TotalUnitCost, ',', '') AS DECIMAL(18,4));

DROP TABLE sales_orders_staging;

-- ------------------------------------------------------------
-- 3. Re-clean 2017_Budgets values via a staging table
-- ------------------------------------------------------------
CREATE TABLE budgets_staging (
    ProductName   VARCHAR(100),
    Budget2017    VARCHAR(30)
);

-- NOTE: budgets_staging is populated by importing the raw CSV
-- (see /data/2017_Budgets.csv) before running the UPDATE below.

UPDATE `2017_budgets` b
JOIN budgets_staging st ON b.`Product Name` = st.ProductName
SET b.`2017 Budgets` = CAST(REPLACE(st.Budget2017, ',', '') AS DECIMAL(18,2));

DROP TABLE budgets_staging;
