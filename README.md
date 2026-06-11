# Omnichannel Retail Sales & Inventory Analytics

## Project Overview

This project focuses on building an end-to-end retail analytics solution for an omnichannel retail business.

The objective is to analyze sales, inventory, customer, product, store, and regional performance using SQL Server, Python, Excel, and Power BI.

The project helps business users:

- Track revenue trends
- Identify top-performing products and stores
- Monitor stock movement
- Reduce dead stock
- Support procurement and inventory planning decisions

---

## Business Problem

Retail businesses operating across multiple stores and sales channels often face challenges in understanding:

- Sales performance
- Inventory movement
- Regional demand patterns
- Product performance

This project addresses these challenges by creating a centralized analytics workflow and interactive Power BI dashboards for different business stakeholders.

---

## Dataset

The project uses a retail dataset that simulates real-world retail operations, including:

- Orders
- Customers
- Products
- Stores
- Inventory
- Dates
- Sales Channels
- Payment Methods

---

## Tech Stack

- SQL Server
- Power BI
- Microsoft Excel
- Python
- Git
- GitHub
- VS Code

---

## Team Members & Responsibilities

| Team Member | Responsibility |
|------------|---------------|
| Utkarsh Dhangar | SQL Development, GitHub Management, Executive Dashboard |
| Neha Bahrela | Store Manager Dashboard, Excel Cleaning, Documentation Management |
| Eishu Tamori | Python EDA, Sales & Operational Insights Dashboard, Inventory Dashboard |
| Jahanvi Pradhan | Excel Cleaning, Regional Sales Director Dashboard |

---

# Project Architecture

```text
Raw Dataset
    ↓
Excel Cleaning + Python EDA
    ↓
Cleaned CSV Files
    ↓
SQL Server Database
    ↓
SQL Analysis + Views
    ↓
Power BI Data Model
    ↓
Interactive Dashboards
    ↓
Business Insights & Recommendations
```

---

## Star Schema

### Sales Model

```text
dim_date_cleaned
        |
        |
dim_customer_cleaned ---- fact_order_cleaned ---- dim_product_cleaned
        |
        |
dim_stores_cleaned
```

### Inventory Model

```text
dim_product_cleaned ---- fact_inventory_cleaned ---- dim_stores_cleaned
```

---

## Tables Used

### Fact Tables

- fact_order_cleaned
- fact_inventory_cleaned

### Dimension Tables

- dim_product_cleaned
- dim_customer_cleaned
- dim_stores_cleaned
- dim_date_cleaned

---

## Key KPIs

### Sales KPIs

- Total Revenue
- Total Orders
- Total Quantity Sold
- Average Order Value (AOV)
- MoM Growth %
- YoY Growth %
- Regional YoY Growth %

### Inventory KPIs

- Total Stock Sold
- Current Stock
- Stock Movement
- Dead Stock Products

---

## SQL Analysis Performed

### Sales Analysis

- Sales KPI Analysis
- Daily Sales Trends
- Monthly Sales Trends
- Quarterly Sales Trends
- Yearly Sales Trends
- Product Performance Analysis
- Category Performance Analysis
- Store Performance Analysis
- City Performance Analysis
- Regional Sales Analysis
- Customer Purchasing Behavior Analysis

### Inventory Analysis

- Inventory Movement Analysis
- Dead Stock Analysis
- Slow-Moving Product Analysis
- Fast-Moving Product Analysis
- Procurement Priority Analysis

### Growth Analysis

- Month-over-Month (MoM) Growth Analysis
- Year-over-Year (YoY) Growth Analysis
- Regional YoY Growth Analysis
- Q4 Seasonality Analysis

---

## SQL Views Created

- vw_monthly_sales_growth
- vw_yearly_sales_growth
- vw_regional_yoy_growth
- vw_procurement_priority

---

# Power BI Dashboards

## 1. Executive Overview Dashboard

Provides high-level business performance through:

- Revenue KPIs
- Revenue Trends
- Category Sales Analysis
- Different time of a day Revenue Analysis
- Slicers (Year, Month, Payment Method, Category, Sales Channel, Region)

---

## 2. Store Manager Dashboard

Focuses on:

- Store-Level KPIs
- Daily Sales Trends
- Weekday vs Weekend Analysis
- Operational Insights

---

## 3. Sales & Operational Insights Dashboard

Provides:

- Sales Trend Analysis
- Operational Performance KPIs
- Month-over-Month Growth
- Year-over-Year Growth

---

## 4. Regional Sales Director Dashboard

Analyzes:

- Regional Revenue Performance
- City Performance
- Store Performance
- Regional YoY Growth
- Store type performance (Mall, Warehuse, Standalone)

---

## 5. Inventory Dashboard

Tracks:

- Inventory based KPIs
- Stock Movement
- Dead Stock Products
- Fast-Moving Products
- Procurement Priority


---

# Dashboard Screenshots

## Executive Overview Dashboard

![Executive Overview](Powerbi/screenshots/Overview%20Dashboard.png)

## Store Manager Dashboard

![Store Manager](Powerbi/screenshots/Store%20Insights%20Dashboard.png)

## Sales & Operational Dashboard

![Sales Dashboard](Powerbi/screenshots/Sales%20&%20Operational%20Dashboard.png)

## Regional Director Dashboard

![Regional Dashboard](Powerbi/screenshots/Regional%20Insights%20Dashboard.png)

## Inventory Dashboard

![Inventory Dashboard](Powerbi/screenshots/Inventory%20Insights%20Dashboard.png)

---

# Project Structure

```text
Omnichannel-Retail-Sales-Inventory-Analytics/
├── data/
│   ├── raw/
│   └── cleaned/
│
├── sql/
│   ├── data_import_and_relationships.sql
│   ├── sales_analysis.sql
│   ├── inventory_analysis.sql
│   ├── sales_growth_analysis.sql
│   ├── business_queries.sql
│   └── views.sql
│
├── notebooks/
│   └── eda_analysis.ipynb
│
├── powerbi/
│   ├── Utkarsh_Executive_Overview.pbix
│   ├── Neha_Store_Manager_Dashboard.pbix
│   ├── Eishu_Sales_Operational_Insights.pbix
│   ├── Jahanvi_Regional_Sales_Director.pbix
│   └── Final_Dashboard.pbix
│
├── docs/
│   ├── data_cleaning_steps.md
│   └── data_dictionary.md
│
├── reports/
│   ├── Omnichannel_Retail_Analytics_Report.pdf
│   └── Omnichannel_Retail_Analytics_Presentation.pptx
│
└── README.md
```


---

# Key Business Insights

### Revenue Insights

- North Region generated the highest revenue at 437.2M with 6,620 total orders
- Q4 demonstrated strong seasonal revenue behavior in both year.
- Evening hours generated the highest revenue (528M) and order volume

### Product Insights

- Beauty and Fashion categories showed strong sales performance.
- Fast-moving products require timely replenishment.

### Inventory Insights

- Several products showed high dead stock risk due to low sales velocity.
- Inventory optimization can significantly improve stock efficiency.

### Strategic Insights

- Overall revenue slightly declined in 2025 compared to 2024.
- Improved sales strategies and inventory planning are recommended.

---

# Future Improvements

- Implement automated Power BI data refresh.
- Build demand forecasting models.
- Add profitability and margin analysis.
- Create role-based dashboard access.
- Deploy cloud-based database infrastructure.

---

# Project Status

| Phase | Status |
|---------|---------|
| Data Cleaning | Completed |
| SQL Analysis | Completed |
| Python EDA | Completed |
| Power BI Dashboard | Completed |
| Documentation | Completed |
| README | In Completed |
| Final Report | In Completed |

---

## Author Contributions

### Eishu Tamori

- Python EDA
- Sales & Operational Insights Dashboard
- Inventory Dashboard
- Business Insights Generation
- Validate the final report

### Utkarsh Dhangar

- SQL Development
- Executive Dashboard
- GitHub Management
- Final Report 

### Neha Bahrela

- Store Manager Dashboard
- Documentation
- Excel Data Cleaning

### Jahanvi Pradhan

- Regional Sales Director Dashboard
- Excel Data Cleaning

---

## License

This project is developed for educational and portfolio purposes.