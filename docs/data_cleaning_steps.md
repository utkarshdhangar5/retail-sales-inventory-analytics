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

