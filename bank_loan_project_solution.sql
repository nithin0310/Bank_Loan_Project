-- Displaying all records from the bank_loan table
SELECT * FROM bank_loan;

-- Counting the total number of records in the bank_loan table
SELECT COUNT(*) FROM bank_loan;

-- Adding a new column to store the converted issue_date as a DATE type
ALTER TABLE bank_loan ADD COLUMN con_issue_date DATE;

-- Disabling safe updates to allow updates without WHERE clauses
SET SQL_SAFE_UPDATES = 0;

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

-- Adding a new column for converted last_credit_pull_date
ALTER TABLE bank_loan ADD COLUMN con_last_credit_pull_date DATE;

-- Updating the con_last_credit_pull_date column by converting various date formats to DATE type
UPDATE bank_loan
SET con_last_credit_pull_date = CASE
    WHEN last_credit_pull_date LIKE '__/__/____' THEN STR_TO_DATE(last_credit_pull_date, '%d/%m/%Y')
    WHEN last_credit_pull_date LIKE '__-__-____' THEN STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y')
    WHEN last_credit_pull_date LIKE '____-__-__' THEN STR_TO_DATE(last_credit_pull_date, '%Y-%m-%d')
    ELSE NULL
END;

-- Dropping the original last_credit_pull_date column
ALTER TABLE bank_loan DROP COLUMN last_credit_pull_date;

-- Adding a new column for converted next_payment_date
ALTER TABLE bank_loan ADD COLUMN con_next_payment_date DATE;

-- Updating the con_next_payment_date column by converting various date formats to DATE type
UPDATE bank_loan
SET con_next_payment_date = CASE
    WHEN next_payment_date LIKE '__/__/____' THEN STR_TO_DATE(next_payment_date, '%d/%m/%Y')
    WHEN next_payment_date LIKE '__-__-____' THEN STR_TO_DATE(next_payment_date, '%d-%m-%Y')
    WHEN next_payment_date LIKE '____-__-__' THEN STR_TO_DATE(next_payment_date, '%Y-%m-%d')
    ELSE NULL
END;

-- Dropping the original next_payment_date column
ALTER TABLE bank_loan DROP COLUMN next_payment_date;

-- Renaming the con_next_payment_date column to next_payment_date
ALTER TABLE bank_loan CHANGE COLUMN con_next_payment_date next_payment_date DATE;

-- Adding a new column for converted last_payment_date
ALTER TABLE bank_loan ADD COLUMN con_last_payment_date DATE;

-- Updating the con_last_payment_date column by converting various date formats to DATE type
UPDATE bank_loan
SET con_last_payment_date = CASE
    WHEN last_payment_date LIKE '__/__/____' THEN STR_TO_DATE(last_payment_date, '%d/%m/%Y')
    WHEN last_payment_date LIKE '__-__-____' THEN STR_TO_DATE(last_payment_date, '%d-%m-%Y')
    WHEN last_payment_date LIKE '____-__-__' THEN STR_TO_DATE(last_payment_date, '%Y-%m-%d')
    ELSE NULL
END;

-- Dropping the original last_payment_date column
ALTER TABLE bank_loan DROP COLUMN last_payment_date;

-- Renaming the con_last_payment_date column to last_payment_date
ALTER TABLE bank_loan CHANGE COLUMN con_last_payment_date last_payment_date DATE;

-- Displaying all records from the bank_loan table after updates
SELECT * FROM bank_loan;

-- Counting the total number of loan applications
SELECT COUNT(id) AS Total_Loan_Application FROM bank_loan;

-- Calculating MTD loan applications for December 2021
SELECT COUNT(id) AS MTD_Loan_Application FROM bank_loan 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating PMTD loan applications for November 2021
SELECT COUNT(id) AS PMTD_Loan_Application FROM bank_loan 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating MOM change in total loan applications
WITH MTD_app AS(
    SELECT COUNT(id) AS MTD_Loan_Application FROM bank_loan 
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_app AS(
    SELECT COUNT(id) AS PMTD_Loan_Application FROM bank_loan 
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Loan_Application - PMTD.PMTD_Loan_Application) / PMTD.PMTD_Loan_Application * 100) AS MOM_Total_Loan_Application 
FROM MTD_app MTD, PMTD_app PMTD;

-- Calculating the total loan amount
SELECT SUM(loan_amount) AS Total_Loan_Amount FROM bank_loan;

-- Calculating MTD loan amount for December 2021
SELECT SUM(loan_amount) AS MTD_Total_Loan_Amount FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating PMTD loan amount for November 2021
SELECT SUM(loan_amount) AS PMTD_Total_Loan_Amount FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating MOM change in total loan amount
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

-- Calculating total amount received
SELECT SUM(total_payment) AS Total_Amount_Recieved FROM bank_loan;

-- Calculating MTD total amount received for December 2021
SELECT SUM(total_payment) AS MTD_Total_Amount_Recieved FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating PMTD total amount received for November 2021
SELECT SUM(total_payment) AS PMTD_Total_Amount_Recieved FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating MOM change in total amount received
WITH MTD_funded AS (
    SELECT SUM(total_payment) AS MTD_Total_Amount_Recieved FROM bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_funded AS (
    SELECT SUM(total_payment) AS PMTD_Total_Amount_Recieved FROM bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Total_Amount_Recieved - PMTD.PMTD_Total_Amount_Recieved) / PMTD.PMTD_Total_Amount_Recieved * 100) AS MOM_Total_Amount_Recieved
FROM MTD_funded MTD, PMTD_funded PMTD;

-- Calculating MTD average interest rate for December 2021
SELECT AVG(int_rate) * 100 AS MTD_Avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating PMTD average interest rate for November 2021
SELECT AVG(int_rate) * 100 AS PMTD_Avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating MOM change in average interest rate
WITH MTD_Avg_interest_rate AS (
    SELECT AVG(int_rate) * 100 AS MTD_Avg_interest_rate FROM bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_Avg_interest_rate AS (
    SELECT AVG(int_rate) * 100 AS PMTD_Avg_interest_rate FROM bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Avg_interest_rate - PMTD.PMTD_Avg_interest_rate) / PMTD.PMTD_Avg_interest_rate * 100) AS MOM_Avg_interest_rate
FROM MTD_Avg_interest_rate MTD, PMTD_Avg_interest_rate PMTD;

-- Calculating MTD DTI for December 2021
WITH MTD_Avg_DTI AS (
    SELECT AVG(dti) * 100 AS MTD_Avg_DTI 
    FROM bank_loan
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_Avg_DTI AS (
    SELECT AVG(dti) * 100 AS PMTD_Avg_DTI 
    FROM bank_loan
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT ((MTD.MTD_Avg_DTI - PMTD.PMTD_Avg_DTI) / PMTD.PMTD_Avg_DTI * 100) AS MOM_Avg_DTI
FROM MTD_Avg_DTI MTD, PMTD_Avg_DTI PMTD;

-- Calculate Good Loan Percentage
SELECT (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)*100)/
COUNT(id) AS Good_Loan_Percentage
FROM bank_loan;

-- Count Total Good Loans
SELECT COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)
AS Total_Good_Loan
FROM bank_loan;

-- Calculate Total Payment Received for Good Loans
SELECT SUM(total_payment) AS Good_Loan_Recieved
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Calculate Bad Loan Percentage
SELECT (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)*100)/
COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan;

-- Calculate Total Loan Amount Funded for Bad Loans
SELECT SUM(loan_amount) AS Bad_Loan_Funded
FROM bank_loan
WHERE loan_status = 'Charged Off';

-- Summarize Loan Data by Loan Status
SELECT loan_status AS Loan_Status,
		COUNT(id) AS Loan_Count,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Amount_Recieved,
        AVG(int_rate*100) AS Interest_Rate,
        AVG(dti*100) AS DTI
FROM bank_loan
GROUP BY loan_status;        

-- Summarize Loan Data by Month of Issue Date
SELECT MONTH(issue_date) AS Month_Number,
		MONTHNAME(issue_date) AS Month,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Payment_Recieved
FROM bank_loan
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date) ASC;        

-- Summarize Loan Data by Address State
SELECT  address_state AS Address,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Payment_Recieved
FROM bank_loan
GROUP BY address_state
ORDER BY address_state;

-- Summarize Loan Data by Term
SELECT  term AS TERM,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Payment_Recieved
FROM bank_loan
GROUP BY term
ORDER BY term;

-- Summarize Loan Data by Loan Purpose
SELECT  purpose AS Purpose,
		AVG(int_rate*100) AS Avg_Interest_Rate,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Payment_Recieved
FROM bank_loan
GROUP BY purpose
ORDER BY purpose;

-- Summarize Loan Data by Home Ownership
SELECT  home_ownership AS Home_Ownership,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Amount_Funded,
        SUM(total_payment) AS Total_Payment_Recieved
FROM bank_loan
GROUP BY home_ownership
ORDER BY home_ownership;

-- Display All Records from Bank Loan Table
SELECT * FROM bank_loan;
