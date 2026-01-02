--Temp table to check if loan table is clean
CREATE TEMP TABLE loan_check AS
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
            CASE WHEN loan_status LIKE 'Does not meet the credit policy%' 
                THEN FALSE 
                ELSE TRUE 
            END AS meets_policy,
            CASE WHEN loan_status LIKE 'Does not meet the credit policy%' 
                THEN SUBSTR(loan_status, INSTR(loan_status,'Status:')+7)
                ELSE loan_status 
            END AS clean_status,
        UPPER(SUBSTR(issue_d, 1, 3)) AS month,
        SUBSTR(issue_d, INSTR(issue_d, '-') + 1) AS year
        FROM loan
    ),
    cleaned AS (
        SELECT 
            n.*, 
            date(n.year || '-' || m.numbered_month || '-01')  AS date 
        FROM new AS n 
        LEFT JOIN months_table AS m
        ON n.month = m.month
    )
SELECT * FROM cleaned;

SELECT * FROM loan_check
LIMIT 10;

PRAGMA table_info(loan_check); --missing datatypes on cid 11, 12, 13, 14, 15

SELECT --Duplicate check
    'SELECT ' || group_concat(name, ', ') ||
    'FROM loan_check
    GROUP BY ' || group_concat(name, ', ') ||
    'HAVING COUNT(*) > 1;'
FROM pragma_table_info('loan_check');

SELECT id, loan_amnt, funded_amnt, term, grade, sub_grade, int_rate, installment, issue_d, loan_status, purpose, meets_policy, clean_status, month, year, date FROM loan_check
    GROUP BY id, loan_amnt, funded_amnt, term, grade, sub_grade, int_rate, installment, issue_d, loan_status, purpose, meets_policy, clean_status, month, year, date HAVING COUNT(*) > 1;

SELECT -- Null check
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END)  AS id_nulls,
    SUM(CASE WHEN loan_amnt IS NULL THEN 1 ELSE 0 END)  AS loan_nulls,
    SUM(CASE WHEN funded_amnt IS NULL THEN 1 ELSE 0 END)  AS funded_null,
    SUM(CASE WHEN term IS NULL THEN 1 ELSE 0 END)  AS term_nulls,
    SUM(CASE WHEN grade IS NULL THEN 1 ELSE 0 END)  AS grade_nulls,
    SUM(CASE WHEN sub_grade IS NULL THEN 1 ELSE 0 END)  AS sub_nulls,
    SUM(CASE WHEN int_rate IS NULL THEN 1 ELSE 0 END)  AS rate_nulls,
    SUM(CASE WHEN installment IS NULL THEN 1 ELSE 0 END)  AS installment_nulls,
    SUM(CASE WHEN issue_d IS NULL THEN 1 ELSE 0 END)  AS date_nulls,
    SUM(CASE WHEN purpose IS NULL THEN 1 ELSE 0 END)  AS purpose_nulls,
    SUM(CASE WHEN clean_status IS NULL THEN 1 ELSE 0 END)  AS status_nulls
FROM loan_check;

--Create new cleaned and standardized loan table
DROP TABLE IF EXISTS loan_cleaned;

CREATE TABLE loan_cleaned(
    id INTEGER PRIMARY KEY,
    loan_amnt INTEGER NOT NULL,
    funded_amnt INTEGER NOT NULL,
    term TEXT NOT NULL,
    grade TEXT NOT NULL,
    sub_grade TEXT NOT NULL,
    int_rate REAL NOT NULL,
    installment REAL NOT NULL,
    purpose TEXT NOT NULL,
    meets_policy INTEGER NOT NULL,
    loan_status TEXT NOT NULL,
    date TEXT NOT NULL
);

INSERT INTO loan_cleaned(id, loan_amnt, funded_amnt, term, grade, sub_grade, int_rate, installment, purpose, meets_policy, loan_status, date)
    SELECT
        id, 
        CAST(loan_amnt AS INTEGER) AS loan_amnt, 
        CAST(funded_amnt AS INTEGER) AS funded_amnt, 
        UPPER(TRIM(term)) AS term,
        UPPER(TRIM(grade)) AS grade,
        UPPER(TRIM(sub_grade)) AS sub_grade,
        ROUND(CAST(int_rate AS REAL), 2) AS int_rate,
        ROUND(CAST(installment AS REAL), 2) AS installment,
        UPPER(TRIM(purpose)) AS purpose,
        CAST(meets_policy AS INTEGER) AS meets_policy,
        UPPER(TRIM(clean_status)) AS loan_status,
        CAST(date AS TEXT) AS date  
FROM loan_check;

SELECT * FROM loan_cleaned
LIMIT 10;

PRAGMA table_info(loan_cleaned);

--Temp table to check if borrower table is clean

CREATE TEMP TABLE borrower_check AS
    WITH cleaned_borrower AS (
        SELECT
            id,
            UPPER(TRIM(home_ownership)) AS home_ownership,    
            CAST(annual_inc AS INTEGER) AS annual_inc,       
            UPPER(TRIM(addr_state)) AS addr_state,      
            ROUND(CAST(dti AS REAL), 2)  AS dti             
        FROM borrower
    )
SELECT * FROM cleaned_borrower;

SELECT * FROM borrower_check
LIMIT 10;

PRAGMA table_info(borrower_check); --missing datatype on cid 1, 3, 4

SELECT --duplicate check
    id,
    home_ownership,
    annual_inc,
    addr_state,
    dti
FROM borrower_check
GROUP BY 
    id,
    home_ownership,
    annual_inc,
    addr_state,
    dti
    HAVING COUNT(*) > 1;

SELECT -- Null check
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END)  AS id_nulls,
  SUM(CASE WHEN home_ownership IS NULL THEN 1 ELSE 0 END)  AS ownership_nulls,
  SUM(CASE WHEN annual_inc IS NULL THEN 1 ELSE 0 END)  AS income_null,
  SUM(CASE WHEN addr_state IS NULL THEN 1 ELSE 0 END)  AS state_nulls,
  SUM(CASE WHEN dti IS NULL THEN 1 ELSE 0 END)  AS dti_nulls
FROM borrower_check;

--Create new cleaned and standardized loan table

DROP TABLE IF EXISTS borrower_cleaned;

CREATE TABLE borrower_cleaned(
    id INTEGER PRIMARY KEY REFERENCES loan_cleaned(id),
    home_ownership TEXT NOT NULL,
    annual_inc INTEGER NOT NULL,
    addr_state TEXT NOT NULL,
    dti REAL NOT NULL
);

INSERT INTO borrower_cleaned(id, home_ownership, annual_inc, addr_state, dti)
    SELECT 
        id,
        CAST(home_ownership AS TEXT) AS home_ownership,
        CAST(annual_inc AS INTEGER) AS annual_inc,
        CAST(addr_state AS TEXT) AS addr_state,
        CAST(dti AS FLOAT) AS dti
FROM borrower_check;

PRAGMA table_info(borrower_cleaned);
SELECT DISTINCT addr_state FROM borrower_cleaned;