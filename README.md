# 📊 Sales Performance Analysis (SQL + Power BI)

## 📌 Overview

This project builds a complete sales analytics data model in MySQL — starting from raw, messy CSV data and ending in a clean, relational database with a single analytical view that powers an interactive Power BI dashboard.

---

## 🎯 Business Objective

The goal is to help business stakeholders track sales performance, profitability, and budget accuracy across years, regions, and products by analyzing:

- Total Sales & Profit
- Profit Margin %
- Sales by Channel (Wholesale / Distributor / Export)
- Top Performing Products
- Budget vs Actual Sales
- Regional Sales Distribution

---

## 🗂 Dataset

Five related tables (sample/practice dataset):

| Table | Description |
|---|---|
| `Customers` | Customer names and IDs |
| `Products` | Product catalog |
| `Regions` | Delivery region, city, and country |
| `Sales_Orders` | ~10,700 order-level transactions (2014–2017) |
| `2017_Budgets` | Budgeted sales value per product for 2017 |

---

## 🛠 Tools Used

- MySQL (data modeling, cleaning, view creation)
- Power BI (dashboard & visualization)
- DAX / Power Query

---

## 🧹 Process

The SQL work is organized into four scripts under [`/sql`](./sql):

1. **`01_schema_and_keys.sql`** — Add primary keys to every table and foreign keys linking `Sales_Orders` to `Customers`, `Products`, and `Regions`; link `2017_Budgets` to `Products`; fix numeric columns imported as text.
2. **`02_data_cleaning.sql`** — Convert `OrderDate` from text to a proper `DATE` type; re-clean numeric columns (`Unit Price`, `Line Total`, `Total Unit Cost`, `2017 Budgets`) that contained comma separators, using temporary staging tables.
3. **`03_view_creation.sql`** — Build `vw_SalesDashboard`, a single view joining all five tables with calculated fields: `Profit`, `Profit Margin %`, and `Budget vs Actual`. This view is the direct data source for the Power BI dashboard.
4. **`04_data_quality_checks.sql`** — Validate the model: duplicate key checks, NULL checks, and orphan-record checks (foreign keys with no matching parent row).

---

## 📈 Dashboard Features

- Year, Channel, Region & Warehouse filters
- KPI cards: Total Orders, Total Sales, Total Profit, Profit Margin %, Average Order Value
- Sales & Profit trend by month
- Sales by Channel (donut chart)
- Top 10 Products by Sales
- Sales & Profit by Customer (margin band scatter plot)
- Budget vs Actual Sales by year
- Regional sales breakdown

---

## 📊 Key KPIs (2014–2017)

| KPI | Value |
|---|---|
| Total Orders | 10.68K |
| Total Sales | 205.99M |
| Total Profit | 76.96M |
| Profit Margin % | 37.36% |
| Average Order Value | 19.28K |

---

## 🖼 Dashboard Preview

![Sales Performance Dashboard](./screenshots/dashboard_screenshot.png)

---

## 📂 Project Files

- `/sql/01_schema_and_keys.sql`
- `/sql/02_data_cleaning.sql`
- `/sql/03_view_creation.sql`
- `/sql/04_data_quality_checks.sql`
- `/powerbi/sql_project.pbix`
- `/screenshots/dashboard_screenshot.png`
- `/data/` — source CSVs (Customers, Products, Regions, Sales_Orders, 2017_Budgets)

---

## 🚀 Author

**Ashish Kumar**
Data Analyst | Power BI | SQL | Python | Excel
