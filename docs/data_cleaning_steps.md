# Retail Sales & Inventory Project

## Data Cleaning & Transformation Steps in Excel

This document contains the data cleaning and transformation process performed in Excel/Power Query for the Retail Sales & Inventory Project.

---

# 1. Fact Order Table

## Cleaning Steps Performed

- Imported CSV file into Excel
- Promoted first row as headers
- Changed data types of required columns
- Removed duplicate rows
- Replaced negative values with `0`
- Removed null/missing values
- Capitalized text values properly

## Feature Engineering / Custom Columns Added

### Sales Features
- Added `Total Price` column
- Added `Order Month` column
- Added `Weekday/Weekend` classification
- Added `Revenue Bucket` column
- Added `Week Name` column
- Added `Order Hour` column
- Added `Hourly Bucket` column

---

# 2. Fact Inventory Table

## Cleaning Steps Performed

- Imported CSV file into Excel
- Promoted first row as headers
- Changed data types of required columns
- Removed duplicate rows
- Replaced negative values with `0`
- Trimmed unwanted spaces from text fields

## Feature Engineering / Custom Columns Added

### Inventory Features
- Added `Inventory Year` column
- Added `Quarterly` classification
- Added `Selling Rate` column
- Added `Stock Movement` column
- Added `Dead Stock` indicator column

---

# Tools Used

- Microsoft Excel
- Power Query

---

# Objective

The purpose of these cleaning and transformation steps was to:

- Improve data quality
- Handle missing and invalid values
- Create meaningful business metrics
- Prepare datasets for analysis and dashboarding
- Enable better reporting and business insights


# 3. Dim Product Table

## Cleaning Steps Performed

- Checked data types of required columns
- Checked duplicate values in `Product ID`
- Handled missing values in `Product Name`
- Handled missing values in `Selling Price`
- Standardized text formatting using:
  - `TRIM()`
  - `CLEAN()`
  - Proper capitalization of each word
- Cleaned product names by removing numeric digits

## Feature Engineering / Custom Columns Added

### Product Features
- Added `Selling Price Bucket` column
- Added `Profit Bucket` column

---

# Purpose of Cleaning

The purpose of these transformations was to:

- Improve product data consistency
- Remove invalid and noisy text values
- Handle incomplete records
- Create categorized pricing and profit segments
- Prepare the product dimension table for reporting and dashboard analysis

=======
## Dim Date Table Cleaning & Enhancement

Performed validation and enhancement of the dim_date table in Excel and Power Query to improve calendar intelligence and reporting usability.

### Tasks Performed:
- Checked for duplicate records in full_date
- Validated missing/null values across all columns
- Verified date consistency and formatting
- Created season column based on month categorization:
  - Winter
  - Summer
  - Monsoon
  - Autumn
- Created festival_season column in Power Query:
  - Oct–Dec → Festive Season
  - Remaining months → Regular Season
- Improved date table usability for Power BI reporting and seasonal trend analysis

### Business Impact:
These enhancements help support:
- Seasonal sales analysis
- Festival demand trend analysis
- Time-based reporting
- Better dashboard filtering and insights

