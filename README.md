# Loan-Lending-Analysis of LendingClub

## Project Overview

LendingClub is a digital marketplace bank that offers various loans, like personal and small business loans, auto refinancing, etc. It began as a peer-to-peer lending company in 2007, but transitioned to a fully chartered bank in 2021 after acquiring Radius Bank. In this project, I analyze a dataset of their loans from 2007 to 2018 to identify trends in funded loan volume, borrower behavior, loan performance, and risk patterns over time. The ultimate goal of this project was to harness these insights to drive strategic decisions about scaling high-performing loan categories while reducing exposure to high-risk borrower segments for the growth and strategy team.

## Executive Summary

LendingClub's funded loan volume has increased significantly from 2007 to 2018, with total annual loan volume increasing from $4.25M in 2007 to $7.51B in 2018, representing a CAGR of 97.37% and a clear inflection point during the 2012–2015 hyper-growth period. Across the portfolio, Debt Consolidation consistently drove the largest share of originations, accounting for 59.62% of cumulative loan volume, with Grades B and C contributing the majority of funded loans. Risk analysis highlights a persistent yield–risk tradeoff: average interest rates increase monotonically from Grade A (~7–9%) to Grade G (~25–30%), while charge-off rates rise from approximately 0-8% to 8-48% with lower-grade segments (E–G) yielding materially higher default intensity across all loan purposes. To optimize risk-adjusted returns, LendingClub should continue scaling mid-grade (B–C) debt consolidation lending, while tightening underwriting, pricing, and exposure limits for lower-grade segments where incremental yield is outweighed by elevated credit risk.

Below is a snapshot of the dashboard used for analysis of the 2018 period. The full interactive dashboard can be found [here](https://public.tableau.com/app/profile/andrew.zou/viz/LoanLending_17538963789000/Dashboard1).

<img width="1461" height="883" alt="image" src="https://github.com/user-attachments/assets/188f65c2-dbc0-41a3-bb4a-80de51ad8254" />

## Data Source

The dataset used in this analysis was sourced from Kaggle and contains historical LendingClub loan-level data spanning 2007–2018. The data originates directly from LendingClub’s publicly released loan records and includes borrower attributes, loan characteristics, performance outcomes, and timestamps. The data set can be found [here](https://www.kaggle.com/datasets/wordsforthewise/lending-club).

## Data Preparation and Cleaning

Before visualization and analysis in Tableau, the raw dataset was cleaned, standardized, and structured using SQL in VSCode using the SQLite extension. 

The original CSV contained approximately 50 text-typed fields. A subset of 16 variables relevant to business, risk, and performance analysis was selected to form a base table, which was then normalized into two relational tables, loans and borrowers, with appropriate data types, primary keys, and constraints to support accurate joins and aggregation.

During data ingestion into VSCode, data quality issues were identified and resolved. Malformed ID values due to embedded non-data rows were identified and removed to avoid silent primary-key collisions during type casting and ensure referential integrity. Additional validation checks using CTEs and temp tables confirmed the absence of duplicate records, null violations, and nonsensical values. Further feature engineering was performed to support downstream analysis, including standardizing loan status fields, creating a new field to verify policy compliance, and deriving time-based attributes from issuance dates. Cleaned and validated tables were materialized as final analysis-ready datasets and subsequently connected to Tableau for visualization and exploratory analysis.


## ERD
The cleaned and normalized database structure is shown below with the borrower and loan tables, with a total row count of 2,260,668.

<img width="586" height="322" alt="image" src="https://github.com/user-attachments/assets/254e5e79-fa23-46f2-ae61-5e1795c54846" />

## Key Insights

### Loan Volume Trends & Growth
- Total funded loan volume increased from $4.25M in 2007 to $7.51B in 2018 with a 97.37% CAGR, with the most rapid expansion occurring between 2012 and 2015, when annual volume grew from $687.17M to $6.21B demonstrating a nearly 9x growth period.
- Annual growth rates peaked above 180% in 2012–2013 but slowed significantly after 2015, with percent growth from the previous year being –1.6% in 2016 and 2.1% in 2017 however in 2018 the percent growth increases again to 20.4% from 2017.
- The non-linear growth trend from 2007 to 2018 indicates LendingClub achieved scale primarily through a short hyper-growth phase rather than steady long-term compounding.

<img width="414" height="258" alt="image" src="https://github.com/user-attachments/assets/94c7c344-28e7-4ec7-bf2b-00c38f33b803" />

### Borrower Grade Distribution
- Grades B and C contributed the majority of funded loan volume during peak growth years (2013–2016), with Grade C emerging as the top contributing grade in 2014–2016, including the platform’s peak year ($6.21B in 2015).
- Although lower-grade segments (D–G) increased in absolute volume (~$2.28M in 2007 to ~$1.37B in 2018) they remained secondary contributors to funded loan volume relative to B–C grades.
- As funded loan volume grew, lower-grade segments generally contributed less to the total volume (~25.7% of total loan volume in 2007 to ~12.41% in 2018), indicating risk-selective growth focused on scalable mid-grade credit.

Loan Volume Distribution in 2007 (top) and 2018 (bottom)
<img width="726" height="242" alt="image" src="https://github.com/user-attachments/assets/341cc6ac-ded6-473f-9636-5dcf11525595" /> <img width="193" height="127" alt="image" src="https://github.com/user-attachments/assets/99f8e5de-c7df-4455-8391-2c05b8933f67" />
<img width="737" height="248" alt="image" src="https://github.com/user-attachments/assets/2644ebc4-f66a-4d48-bd9f-76d0d52b5c72" />

### Charge-Off Behavior
- Charge-off rates increased non-linearly from ~0–8% in Grades A–B to as high as ~48% in Grades F–G indicating diminishing marginal returns in lower-grade lending
- The number of charged-off loans increased from 158 in 2007 to 75,803 in 2015, closely tracking rapid origination growth.
- Post-2015, charge-off counts declined sharply by ~88.3% from 2015 to 2018 (75,803 in 2015; 68,242 in 2016; 39,148 in 2017; 8,867 in 2018), even as annual loan volume remained above $6B which suggests improved underwriting discipline and risk controls as growth slowed and demonstrates materially higher risk-adjusted growth efficiency as underwriting tightened
- While average interest rates rose monotonically across grades (A: ~7–9% to G: ~25–30%), the disproportionately higher charge-off rates in Grades F–G suggest that incremental yield did not fully compensate for credit losses at the lowest credit tiers.

<img width="418" height="361" alt="image" src="https://github.com/user-attachments/assets/5aa06a02-e56a-4fbe-ad49-e2dc185bee03" />
<img width="427" height="361" alt="image" src="https://github.com/user-attachments/assets/829e1bf4-5542-4411-8ef8-30ef4ce93c4f" />

### Risk Across Grades and Purposes
- Grades E–G consistently exhibited elevated charge-off rates across all loan purposes, including Debt Consolidation, Credit Card, and Small Business loans, demonstrating that default risk is primarily driven by borrower credit quality rather than loan intent.
- Small Business loans display higher charge-off rates at comparable grades despite contributing a smaller share of total volume, which suggests that Small Business lending carries disproportionately high risk relative to its growth contribution than other categories, such as Debt Consolidation.

<img width="867" height="303" alt="image" src="https://github.com/user-attachments/assets/22979c3a-1cf6-4952-b390-f4bdde29a279" />










