PRAGMA table_info(accepted); --Check datatypes of fields in accepted table
--Base table of only relevant fields from accepted table to refer to
WITH base AS( 
    SELECT
        id,
        loan_amnt,
        funded_amnt,
        term,
        int_rate,
        installment,
        grade,
        sub_grade,
        home_ownership, 
        annual_inc,
        issue_d,
        loan_status,
        purpose,
        addr_state,
        dti
    FROM accepted
)
SELECT * FROM base 
LIMIT 10

--Split base table into 2 separate tables for organization and clarity

--Create loan table from accepted table
DROP TABLE IF EXISTS loan;

CREATE TABLE loan(
    id INTEGER PRIMARY KEY,
    loan_amnt INTEGER NOT NULL,
    funded_amnt INTEGER NOT NULL,
    term TEXT NOT NULL,
    grade TEXT NOT NULL,
    sub_grade TEXT NOT NULL,
    int_rate REAL NOT NULL,
    installment REAL NOT NULL, 
    issue_d TEXT NOT NULL,
    loan_status TEXT NOT NULL, 
    purpose TEXT NOT NULL
);

INSERT OR IGNORE INTO loan(id, loan_amnt, funded_amnt, term, grade, sub_grade, int_rate, installment, issue_d, loan_status, purpose)
SELECT 
    CAST(id AS INTEGER), 
    CAST(loan_amnt AS INTEGER), 
    CAST(funded_amnt AS INTEGER), 
    term, 
    grade, 
    sub_grade, 
    CAST(int_rate AS FLOAT), 
    CAST(installment AS FLOAT), 
    issue_d, 
    loan_status, 
    purpose
FROM accepted;

SELECT * FROM loan
LIMIT 100;

--Create borrower table from accepted table
DROP TABLE IF EXISTS borrower;

CREATE TABLE borrower(
    id INTEGER PRIMARY KEY REFERENCES loan(id),
    home_ownership TEXT NOT NULL,
    annual_inc INTEGER NOT NULL,
    addr_state TEXT NOT NULL,
    dti REAL NOT NULL
);

INSERT INTO borrower(id, home_ownership, annual_inc, addr_state, dti)
SELECT  
    CAST(id AS INTEGER),
    home_ownership,
    CAST(annual_inc AS INTEGER),
    addr_state,
    CAST(dti AS FLOAT)
FROM accepted;

SELECT * FROM borrower
LIMIT 100;

