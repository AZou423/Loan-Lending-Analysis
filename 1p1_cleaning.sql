--Cleaning loan table
SELECT DISTINCT loan_status FROM loan;

SELECT * FROM loan
LIMIT 10

WITH months_table(month, numbered_month) AS (
    VALUES
        ('JAN','01'),('FEB','02'),('MAR','03'),
        ('APR','04'),('MAY','05'),('JUN','06'),
        ('JUL','07'),('AUG','08'),('SEP','09'),
        ('OCT','10'),('NOV','11'),('DEC','12')
),
new AS (
    SELECT
        loan.*,
        --Create meets policy flag that checks if loan meets credit policy
        CASE WHEN loan_status LIKE 'Does not meet the credit policy%' 
            THEN FALSE 
            ELSE TRUE 
        END AS meets_policy,
        --Remove prefix on cases where loan doesn't meet credit policy
        CASE WHEN loan_status LIKE 'Does not meet the credit policy%' 
            THEN SUBSTR(loan_status, INSTR(loan_status,'Status:')+7)
            ELSE loan_status 
        END AS clean_status,
    --Split date into month and year
    UPPER(SUBSTR(issue_d, 1, 3)) AS month,
    SUBSTR(issue_d, INSTR(issue_d, '-') + 1) AS year
    FROM loan
), --Use numbered months to create a proper date
cleaned AS (
    SELECT 
        n.*, 
        date(n.year || '-' || m.numbered_month || '-01')  AS date 
    FROM new AS n 
    LEFT JOIN months_table AS m
    ON n.month = m.month
)
SELECT * FROM cleaned
LIMIT 10;

--Validate that loan table is clean in 2p1_validation.sql using temp table


--Cleaning borrower table

--Ensure borrower has same number of rows as loan since it references loan (should be one-to-one)
SELECT COUNT(*) FROM borrower;
SELECT COUNT(*) FROM loan;

SELECT * FROM borrower
LIMIT 10;

--Standardize fields 
WITH cleaned_borrower AS (
  SELECT
    id,
    UPPER(TRIM(home_ownership)) AS home_ownership,    
    CAST(annual_inc AS INTEGER) AS annual_inc,       
    UPPER(TRIM(addr_state)) AS addr_state,      
    ROUND(CAST(dti AS REAL), 2)  AS dti             
  FROM borrower
)
SELECT * FROM cleaned_borrower
LIMIT 10;

--Validate that borrower table is clean in 2p1_validation.sql using temp table


