# Customer Churn Analysis (Telecom Industry)

This project analyzes customer churn for a fictional telecommunications company.  It includes a sample dataset, a SQL script for exploratory data analysis (EDA), a Python script to generate visualizations, and this README to explain the purpose and usage of each component.  The goal is to understand factors that contribute to customer attrition and to provide insights for business stakeholders.

## 1. Data File & Source

The dataset used in this project is based on the **Telco customer churn** sample data module published by IBM, which tracks a fictional telco company's customer churn.  The source dataset contains around 7043 customer records with 21 features covering demographics, account information, service usage, and churn status.  

Key columns include:

- **customerID**: unique identifier for each customer  
- **gender**, **SeniorCitizen**, **Partner**, **Dependents**: demographic attributes  
- **tenure**: number of months the customer has been with the company  
- **PhoneService**, **MultipleLines**, **InternetService**, **OnlineSecurity**, **OnlineBackup**, **DeviceProtection**, **TechSupport**, **StreamingTV**, **StreamingMovies**: service usage features  
- **Contract**, **PaperlessBilling**, **PaymentMethod**: contract and billing information  
- **MonthlyCharges**, **TotalCharges**: billing amounts  
- **Churn**: whether the customer churned in the last month

Because internet download is disabled in this environment, a synthetic sample dataset (`customer_churn_sample.csv`) with 100 rows has been created using similar columns and value distributions.  This file is provided for demonstration and can be replaced with the official dataset when running the project locally.

## 2. Analytics File (SQL)

The SQL script (`churn_analysis.sql`) performs basic and intermediate EDA on the dataset.  Each query includes comments explaining why specific SQL functions are used so that someone new to SQL or a business analytics manager can quickly understand the purpose.

Highlights of the SQL analysis:

- **Counting records** using `COUNT(*)` to determine total customers.  
- **Calculating churn rate** via conditional counts inside `COUNT(CASE WHEN … THEN … END)` and computing percentages with arithmetic and `ROUND()`.  
- **Computing averages** for tenure, monthly charges, and total charges with `AVG()` and summarizing churn counts with `SUM()` for conditional counting.  
- **Grouping** by contract or payment method using `GROUP BY` to compare churn rates across categories.  
- **Creating tenure bands** with `CASE` statements to bucket customers into ranges (e.g., 0–1 year, 1–2 years) and calculate churn rate per band.  
- **Identifying high-value at‑risk customers** by selecting churned customers whose monthly and total charges exceed the overall average.  
- **Using window functions** (`AVG() OVER (…)`) to compute a running average of monthly charges within each contract type.  

To execute the SQL script:

1. Load `customer_churn_sample.csv` into your preferred relational database (e.g., SQLite, PostgreSQL) as a table named `telco_churn`.  
2. Run the queries in `churn_analysis.sql` sequentially or individually.  
3. Inspect the results to understand churn patterns and key factors.

## 3. Visualization Files

The Python script (`churn_visualizations.py`) reads the dataset and produces several charts using **matplotlib**.  Each chart is saved as an image file when run locally.  The script creates:

1. **Churn Distribution** – a bar chart showing the count of churned vs retained customers.  
2. **Tenure Distribution** – a histogram illustrating how long customers have been with the company.  
3. **Monthly Charges Distribution** – a histogram of monthly billing amounts.  
4. **Churn by Contract Type** – a stacked bar chart comparing churn vs non‑churn across contract categories (Month‑to‑month, One year, Two year).  
5. **Churn by Tenure Band** – a stacked bar chart showing churn counts within tenure ranges (e.g., 0–1 year, 1–2 years).  

Running the script:

```bash
python churn_visualizations.py
