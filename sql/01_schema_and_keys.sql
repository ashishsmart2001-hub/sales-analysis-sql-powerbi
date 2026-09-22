-- ============================================================
-- 01_schema_and_keys.sql
-- Purpose: Set up primary keys, foreign key relationships between
--          Customers, Products, Regions, Sales_Orders and 2017_Budgets,
--          and fix column data types imported as text.
-- Database: project
-- ============================================================

USE project;

-- ------------------------------------------------------------
-- 1. Primary Keys
-- ------------------------------------------------------------
ALTER TABLE customers
ADD PRIMARY KEY (`Customer Index`);

ALTER TABLE products
ADD PRIMARY KEY (`Index`);

ALTER TABLE regions
ADD PRIMARY KEY (`iNDEX`);

-- OrderNumber needs to be VARCHAR before it can be used as a primary key
ALTER TABLE sales_orders
MODIFY OrderNumber VARCHAR(20);

ALTER TABLE sales_orders
ADD PRIMARY KEY (OrderNumber);

-- ------------------------------------------------------------
-- 2. Foreign Keys (linking Sales_Orders to its dimension tables)
-- ------------------------------------------------------------
ALTER TABLE sales_orders
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY (`Customer Name Index`)
REFERENCES customers(`Customer Index`);

ALTER TABLE sales_orders
ADD CONSTRAINT fk_sales_product
FOREIGN KEY (`Product Description Index`)
REFERENCES products(`Index`);

ALTER TABLE sales_orders
ADD CONSTRAINT fk_sales_region
FOREIGN KEY (`Delivery Region Index`)
REFERENCES regions(`Index`);

-- ------------------------------------------------------------
-- 3. Linking 2017_Budgets to Products (budgets file has no shared
--    numeric key, so we add one and populate it by matching on name)
-- ------------------------------------------------------------
ALTER TABLE `2017_budgets`
ADD COLUMN `Product Index` INT;

UPDATE `2017_budgets` b
JOIN products p
    ON b.`Product Name` = p.`Product Name`
SET b.`Product Index` = p.`Index`;

ALTER TABLE `2017_budgets`
ADD CONSTRAINT fk_budget_product
FOREIGN KEY (`Product Index`)
REFERENCES products(`Index`);

-- ------------------------------------------------------------
-- 4. Data type fixes (numeric columns imported as text)
-- ------------------------------------------------------------
ALTER TABLE sales_orders
MODIFY COLUMN `Unit Price` DECIMAL(10,2),
MODIFY COLUMN `Line Total` DECIMAL(10,2),
MODIFY COLUMN `Total Unit Cost` DECIMAL(10,2);

ALTER TABLE `2017_budgets`
MODIFY COLUMN `2017 Budgets` DECIMAL(10,2);
