# Bank Loan Data Analysis using SQL

## Description

This project involves analyzing a **Bank Loan dataset** using SQL to derive meaningful insights and calculate various KPIs. The dataset includes details like loan issue dates, payment history, interest rates, loan purposes, home ownership status, and more. The objective was to clean, transform, and analyze the data to uncover trends, calculate metrics, and summarize the data based on multiple dimensions.

---

## Features

1. **Data Cleaning & Transformation**:
   - Standardized inconsistent date formats using `STR_TO_DATE` for multiple date columns (e.g., `issue_date`, `last_credit_pull_date`).
   - Replaced original columns with cleaned and converted date formats.

2. **Key Performance Indicators (KPIs)**:
   - **Total Loan Applications**: Count of all loan applications.
   - **Month-to-Date (MTD) Loan Applications** for December 2021.
   - **Previous Month-to-Date (PMTD) Loan Applications** for November 2021.
   - **Month-over-Month (MOM) Change** in loan applications and loan amounts.
   - **Total Loan Amount Funded** and **Total Amount Received**.
   - **Average Interest Rate** and **Average Debt-to-Income (DTI)** ratio by month.

3. **Loan Quality Analysis**:
   - **Good Loan Percentage**: Loans with status `Fully Paid` or `Current`.
   - **Bad Loan Percentage**: Loans with status `Charged Off`.
   - **Total Payment Received for Good Loans**.
   - **Loan Amount Funded for Bad Loans**.

4. **Data Summarization**:
   - By Loan Status (e.g., `Fully Paid`, `Current`, `Charged Off`).
   - By Issue Month.
   - By Address State.
   - By Loan Term (e.g., `36 months`, `60 months`).
   - By Loan Purpose (e.g., `Debt Consolidation`, `Home Improvement`).
   - By Home Ownership (e.g., `OWN`, `MORTGAGE`, `RENT`).

---

## SQL Queries

### Data Cleaning and Transformation
```sql
-- Adding a new column to store the converted issue_date as a DATE type
ALTER TABLE bank_loan ADD COLUMN con_issue_date DATE;

-- Updating the con_issue_date column by converting various date formats to DATE type
UPDATE bank_loan
SET con_issue_date = CASE
    WHEN issue_date LIKE '__/__/____' THEN STR_TO_DATE(issue_date, '%d/%m/%Y')
    WHEN issue_date LIKE '__-__-____' THEN STR_TO_DATE(issue_date, '%d-%m-%Y')
    WHEN issue_date LIKE '____-__-__' THEN STR_TO_DATE(issue_date, '%Y-%m-%d')
    ELSE NULL
END;

-- Dropping the original issue_date column
ALTER TABLE bank_loan DROP COLUMN issue_date;

-- Renaming the con_issue_date column to issue_date
ALTER TABLE bank_loan CHANGE COLUMN con_issue_date issue_date DATE;

-- Repeat similar steps for `last_credit_pull_date`, `next_payment_date`, and `last_payment_date`.


## KPI Calculations

-- Total Loan Applications
SELECT COUNT(id) AS Total_Loan_Application FROM bank_loan;

-- Month-to-Date (MTD) Loan Applications for December 2021
SELECT COUNT(id) AS MTD_Loan_Application 
FROM bank_loan 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous Month-to-Date (PMTD) Loan Applications for November 2021
SELECT COUNT(id) AS PMTD_Loan_Application 
FROM bank_loan 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Month-over-Month (MOM) Change in Loan Applications
WITH MTD_app AS (
    SELECT COUNT(id) AS MTD_Loan_Application 
    FROM bank_loan 
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_app AS (
    SELECT COUNT(id) AS PMTD_Loan_Application 
    FROM bank_loan 
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Loan_Application - PMTD.PMTD_Loan_Application) / PMTD.PMTD_Loan_Application * 100) AS MOM_Total_Loan_Application 
FROM MTD_app MTD, PMTD_app PMTD;

-- Total Loan Amount Funded
SELECT SUM(loan_amount) AS Total_Loan_Amount FROM bank_loan;

-- Month-over-Month (MOM) Change in Loan Amount
WITH MTD_funded AS (
    SELECT SUM(loan_amount) AS MTD_Total_Loan_Amount FROM bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_funded AS (
    SELECT SUM(loan_amount) AS PMTD_Total_Loan_Amount FROM bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Total_Loan_Amount - PMTD.PMTD_Total_Loan_Amount) / PMTD.PMTD_Total_Loan_Amount * 100) AS MOM_Total_Loan_Amount
FROM MTD_funded MTD, PMTD_funded PMTD;

-- Good Loan Percentage
SELECT (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)*100)/
COUNT(id) AS Good_Loan_Percentage
FROM bank_loan;

-- Bad Loan Percentage
SELECT (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)*100)/
COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan;

## Data Summarization

-- Summarizing Loan Data by Loan Status
SELECT loan_status AS Loan_Status,
		COUNT(id) AS Loan_Count,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Amount_Recieved,
        AVG(int_rate*100) AS Interest_Rate,
        AVG(dti*100) AS DTI
FROM bank_loan
GROUP BY loan_status;

-- Summarizing Loan Data by Month of Issue Date
SELECT MONTH(issue_date) AS Month_Number,
		MONTHNAME(issue_date) AS Month,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Payment_Recieved
FROM bank_loan
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date) ASC;

-- Summarizing Loan Data by Address State
SELECT  address_state AS Address,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Payment_Recieved
FROM bank_loan
GROUP BY address_state
ORDER BY address_state;

