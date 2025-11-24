-- Telco Customer Churn Analysis SQL
-- This script performs basic exploratory data analysis (EDA) on the Telco customer churn dataset.
-- Each query includes comments explaining why each SQL function is used so that a beginner
-- and a business analytics manager can quickly understand the purpose of the operations.

-- 1. Get the total number of customers in the dataset.
--    COUNT(*) counts all rows in the table.
SELECT COUNT(*) AS total_customers
FROM customer_churn_sample;

-- 2. Calculate the number of churned and retained customers and the churn rate.
--    COUNT(CASE WHEN ...) counts rows that satisfy a specific condition.
--    ROUND() rounds a numeric value to the specified number of decimal places.
SELECT
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN Churn = 'No' THEN 1 END) AS retained_customers,
    ROUND( (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*)) * 100, 2 ) AS churn_rate_percentage
FROM customer_churn_sample;

-- 3. Compute average tenure and billing metrics.
--    AVG() returns the average value of a numeric column.
--    SUM() returns the total sum of a numeric column.
--    ROUND() is used for presentation.
SELECT
    AVG(tenure) AS avg_tenure_months,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS total_churned
FROM customer_churn_sample;

-- 4. Churn rate by contract type.
--    GROUP BY groups rows that have the same values in specified columns.
--    COUNT() and ROUND() compute counts and rates within each group.
SELECT
    Contract,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_customers,
    ROUND( (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*)) * 100, 2 ) AS churn_rate_percentage
FROM customer_churn_sample
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;

-- 5. Churn rate by payment method.
--    Payment methods may indicate convenience or satisfaction levels; analyzing churn by payment method can reveal patterns.
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_customers,
    ROUND( (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*)) * 100, 2 ) AS churn_rate_percentage
FROM customer_churn_sample
GROUP BY PaymentMethod
ORDER BY churn_rate_percentage DESC;

-- 6. Tenure distribution by churn status.
--    CASE statements create tenure bands to bucket customers into ranges.
--    COUNT() counts customers in each bucket.
SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-1 year'
        WHEN tenure BETWEEN 13 AND 24 THEN '1-2 years'
        WHEN tenure BETWEEN 25 AND 36 THEN '2-3 years'
        WHEN tenure BETWEEN 37 AND 48 THEN '3-4 years'
        WHEN tenure BETWEEN 49 AND 60 THEN '4-5 years'
        ELSE '5+ years'
    END AS tenure_band,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_customers,
    ROUND( (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*)) * 100, 2 ) AS churn_rate_percentage
FROM customer_churn_sample
GROUP BY
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-1 year'
        WHEN tenure BETWEEN 13 AND 24 THEN '1-2 years'
        WHEN tenure BETWEEN 25 AND 36 THEN '2-3 years'
        WHEN tenure BETWEEN 37 AND 48 THEN '3-4 years'
        WHEN tenure BETWEEN 49 AND 60 THEN '4-5 years'
        ELSE '5+ years'
    END
ORDER BY churn_rate_percentage DESC;

-- 7. Advanced: Identify high-value customers likely to churn.
--    This query selects customers with high MonthlyCharges and high total charges
--    and uses ORDER BY to rank them by TotalCharges.
SELECT
    customerID,
    MonthlyCharges,
    TotalCharges,
    tenure,
    Contract,
    Churn
FROM customer_churn_sample
WHERE Churn = 'Yes'
AND MonthlyCharges > (SELECT AVG(MonthlyCharges) FROM telco_churn)
AND TotalCharges > (SELECT AVG(TotalCharges) FROM telco_churn)
ORDER BY TotalCharges DESC;

-- 8. Advanced: Calculate running average of monthly charges using window functions.
--    AVG() OVER() computes a moving average across rows in a specified order.
--    PARTITION BY groups rows; ORDER BY defines the sequence within each partition.
SELECT
    customerID,
    tenure,
    MonthlyCharges,
    AVG(MonthlyCharges) OVER (PARTITION BY Contract ORDER BY tenure ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg_monthly_charges
FROM customer_churn_sample
ORDER BY Contract, tenure;
