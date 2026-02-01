--Total admissions per month and year.
SELECT DISTINCT COUNT(PATIENT_ID) AS 'Total Patient',
YEAR(DATE_OF_ADMISSION) AS Year,
MONTH(DATE_OF_ADMISSION) AS Month
FROM Healthcare_analysis
GROUP BY YEAR(DATE_OF_ADMISSION),MONTH(DATE_OF_ADMISSION)
ORDER BY 2,3 



--Hospitals with number of admissions.
SELECT Hospital,
COUNT(PATIENT_ID) AS 'Total Patient'
FROM Healthcare_analysis
GROUP BY Hospital
Order BY 'Total Patient' DESC




--Top 5 Doctors who handeled the most patients.
SELECT TOP 5 Doctor,
Count(Patient_ID) AS 'Total Patient'
FROM Healthcare_analysis
GROUP BY Doctor
ORDER BY  'Total Patient' DESC



--Gender wise admission.
SELECT Gender,
COUNT(Patient_ID) AS 'Total Patient'
FROM Healthcare_analysis
GROUP BY Gender



--Average Duration of stay per medical condition.
SELECT Medical_condition,
AVG(ADMIT_DAYS) AS 'Average Admit Days'
FROM Healthcare_analysis
GROUP BY Medical_Condition



--Patient whose stay is longer than the average.
SELECT Patient_ID , Admit_Days
FROM Healthcare_analysis
WHERE Admit_Days >
(Select avg(Admit_days)
from Healthcare_analysis)



--Admission type that leads to longest stay duration.
SELECT Medical_condition , 
Admit_Days
FROM Healthcare_analysis
ORDER BY Admit_Days DESC



--Average Stay per age group
SELECT Age,
AVG(ADMIT_DAYS) AS 'Average Admit Days'
FROM Healthcare_analysis
GROUP BY Age
Order by 'Average Admit Days' desc



--Total bill paid by each insurance provider.
SELECT Insurance_Provider,
SUM(Billing_amount) AS 'Billing Amount'
FROM HEALTHCARE_ANALYSIS
GROUP BY Insurance_Provider
ORDER BY 2 DESC



--Average bill amount paid by per medical condition.
SELECT Medical_condition,
SUM(Billing_amount) AS 'Billing Amount'
FROM Healthcare_analysis
GROUP BY Medical_Condition
ORDER BY 2 DESC



--Patients whose billing amount is above hospital average.
SELECT Patient_ID,
Billing_Amount 
FROM HEALTHCARE_ANALYSIS
WHERE BILLING_AMOUNT >
(
SELECT AVG(BILLING_AMOUNT) AS 'Average Billing Amount'
FROM Healthcare_analysis
)



--Rank Hospital by total revenue generated.
SELECT Hospital, SUM(Billing_amount) AS [Total Sales],
DENSE_RANK() OVER (ORDER BY SUM(BILLING_AMOUNT) DESC) Rank
FROM Healthcare_analysis
GROUP BY Hospital
ORDER BY [Total Sales] desc



--Per day cost per patient.
SELECT Patient_ID, (billing_amount/admit_days) AS 'Per day Cost'
FROM Healthcare_analysis



--Percentage of abnormal test results per medical condition.
SELECT Medical_condition,
COUNT(*) AS Total_Patients,
SUM(CASE WHEN Test_results = 'Abnormal' THEN 1 ELSE 0 END) AS Abnormal_Count,
(SUM(CASE WHEN Test_results = 'Abnormal' THEN 1 ELSE 0 END) * 100.0)  /COUNT(*)AS Abnormal_Percentage
FROM Healthcare_analysis
GROUP BY Medical_condition
ORDER BY Abnormal_Percentage DESC



--High risk patient: age> 60 and abnormal test result.
SELECT Patient_id, Age, Test_Results
FROM Healthcare_analysis
WHERE AGE> 60
AND Test_Results = 'Abnormal'



--Conditions with highest abnormal test.
SELECT Medical_Condition ,
sum(CASE WHEN TEST_RESULTS = 'Abnormal' then 1 else 0 end) as 'Test Result'
FROM Healthcare_analysis
GROUP BY Medical_Condition



--Doctors handling most abnormal test cases.
SELECT Doctor, count(patient_id) as 'Total Patient'
FROM Healthcare_analysis
WHERE Test_Results = 'Abnormal'
GROUP BY Doctor
ORDER BY 2 DESC



--Top 3 costly conditions per hospital.
with cte as 
(
SELECT HOSPITAL, MEDICAL_CONDITION , SUM(BILLING_AMOUNT) AS 'Total Amount',
DENSE_RANK() OVER (PARTITION BY HOSPITAL ORDER BY SUM(BILLING_AMOUNT) DESC) RANK
FROM Healthcare_analysis
GROUP BY Hospital,Medical_Condition
)
SELECT * FROM CTE WHERE RANK <= 3



--Rank insurance providers by revenue contribution.
SELECT Insurance_Provider,sum(billing_amount) as 'Total Amount',
DENSE_RANK() over (order by sum(billing_amount) desc ) Rank
FROM Healthcare_analysis
GROUP BY Insurance_Provider



--Month-over-Month Admission growth.
WITH Monthly_Admissions AS (
SELECT
FORMAT(Date_of_admission, 'yyyy-MM') AS Admission_Month,
COUNT(*) AS Total_Admissions
FROM Healthcare_analysis
GROUP BY FORMAT(Date_of_admission, 'yyyy-MM')
)
SELECT Admission_Month,
Total_Admissions,
LAG(Total_Admissions) OVER (ORDER BY Admission_Month) AS Previous_Month_Admissions,
((Total_Admissions - LAG(Total_Admissions) OVER (ORDER BY Admission_Month)) * 100.0)
/ LAG(Total_Admissions) OVER (ORDER BY Admission_Month) AS MoM_Growth_Percentage
FROM Monthly_Admissions
ORDER BY Admission_Month



--YoY Admission growth.
WITH CTE AS (
SELECT year(DATE_OF_ADMISSION) AS Admission_year,
count(*) as Total_Admission 
from Healthcare_analysis
group by  year(DATE_OF_ADMISSION)
)
SELECT Admission_year, Total_Admission ,
LAG(Total_Admission) over(order by Admission_year) as Previous_year_growth,
( (Total_Admission - LAG(Total_Admission) over(order by Admission_year)) * 100.0)
/ LAG(Total_Admission) over(order by Admission_year) AS YoY_growth_percentage
from CTE
ORDER BY Admission_year

















