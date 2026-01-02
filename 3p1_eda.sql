SELECT * FROM loan_cleaned
LIMIT 10;

SELECT * FROM borrower_cleaned
LIMIT 10;

--Checking if tableau calculations are correct
WITH n AS(
    SELECT SUM(funded_amnt) AS volume_filtered FROM loan_cleaned
    WHERE date LIKE '2009%'
        AND grade = 'A'
        AND purpose = 'CREDIT_CARD'
),
m AS(
    SELECT SUM(funded_amnt) AS CY_Volume FROM loan_cleaned
        WHERE date LIKE '2009%'
)
SELECT volume_filtered, CY_Volume, (CAST(volume_filtered AS FLOAT)/CY_Volume) * 10
FROM n 
FULL JOIN m;

WITH n AS(
    SELECT SUM(funded_amnt) AS volume_filtered FROM loan_cleaned
    WHERE date LIKE '2009%'
        AND grade = 'A'
        AND purpose = 'CREDIT_CARD'
),
m AS(
    SELECT SUM(funded_amnt) AS CY_Volume FROM loan_cleaned
    WHERE date LIKE '2009%'
)
SELECT volume_filtered, CY_Volume FROM n
FULL JOIN m;

WITH n AS(
    SELECT SUM(funded_amnt) AS orig FROM loan_cleaned
    WHERE date LIKE '2018%'
)
SELECT orig - SUM(funded_amnt) FROM loan_cleaned
FULL JOIN n  
WHERE date LIKE '2018%' AND purpose = 'OTHER'

SELECT
    purpose, 
    SUM(loan_amnt) 
FROM loan_cleaned
WHERE date like '2007%'
GROUP BY purpose

SELECT
    SUM(loan_amnt) 
FROM loan_cleaned
WHERE date like '2007%' AND purpose != 'OTHER'

SELECT
    SUM(loan_amnt) 
FROM loan_cleaned
WHERE date like '2007%'

SELECT
    SUM(funded_amnt) , purpose
FROM loan_cleaned
WHERE date like '2007%' AND grade = 'C'
GROUP BY purpose

--See every year and what the top grade and purpose are

--Top purpose yearly
WITH n AS(
    SELECT DISTINCT strftime('%Y', date) AS year, purpose, grade, SUM(funded_amnt) AS funded FROM loan_cleaned 
    GROUP BY year, grade, purpose
),
p AS(
    SELECT year, purpose, SUM(funded) AS purpose_funded FROM n
    GROUP BY year, purpose
),
max AS(
    SELECT year, purpose, MAX(purpose_funded) FROM p 
    GROUP BY year
)
SELECT * FROM max
ORDER BY year ASC

--Top grade yearly
WITH n AS(
    SELECT DISTINCT strftime('%Y', date) AS year, purpose, grade, SUM(funded_amnt) AS funded FROM loan_cleaned 
    GROUP BY year, grade, purpose
),
g AS(
    SELECT year, grade, SUM(funded) AS grade_funded FROM n
    GROUP BY year, grade
),
max2 AS(
    SELECT year, grade, MAX(grade_funded) FROM g
    GROUP BY year
)
SELECT * FROM max2
ORDER BY year ASC

SELECT COUNT(*) AS totalChargeoff, loan_status FROM loan_cleaned
WHERE loan_status = 'CHARGED OFF' AND date LIKE '2007%'

SELECT COUNT(*) AS loans_grade, grade FROM loan_cleaned
WHERE date LIKE '2007%'
GROUP BY grade

SELECT
  grade,
  AVG(int_rate) AS avg_interest
FROM loan_cleaned
WHERE date LIKE '2007%'
GROUP BY grade
ORDER BY avg_interest DESC;




