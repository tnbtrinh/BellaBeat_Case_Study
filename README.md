# FITBIT WELLNESS TECHNOLOGY ANALYSIS
In this case study, I will perform a real world tasks of a jumior data analyst. I imagine myself working for [BellaBeat](https://bellabeat.com/), a high tech manufacturer of health-focused products for women.
Urška Sršen, cofounder and Chief Creative Officer of Bellabeat, believes that analyzing smart device fitness data could help unlock new growth opportunities for the company. I have been asked to focus on one of Bellabeat’s products and analyze smart device data to gain insight into how consumers are using their smart devices. The insights I discover will then help guide marketing strategy for the company. I will present my analysis to the Bellabeat executive team along with my high-level recommendations for Bellabeat’s marketing strategy.

### Business Task
Sršen asks me to analyze smart device usage data in order to gain insight into how consumers use non-Bellabeat smart devices. She then wants me to select one Bellabeat product to apply these insights to in my presentation.

Following three points are the questions needed to be answered by this analysis.
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?

## PREPARE
To answer Bellabeat's business tasks I will be using [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) (CC0: Public Domain, dataset made available through Mobius): This Kaggle data set contains personal fitness tracker from thirty fitbit users. Thirty eligible Fitbit users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits.
However, the FitBit Fitness Tracker Data was collected in 2016 making the datasets outdated for current trend analysis. Additionally, while the data initially states a time range of 03-12-2016 to 05-12-2016, after data verification, the data collected was only during a 31 day period (04-12-2016 to 05-12-2016). Since the data only included instances over a 31 day period, the timeframe for a more insightful analysis is relatively small.

I have used Microsoft SQL Server Management Studio for this project to help process and analyze and for visualization I have used Excel. In order to solve this business task, only 3 of the given 18 datasets were used.

## PROCESS
Clean and format data to be more meaningful and clearer. In this step, I have organized data by adding columns, extracting information, and removing bad data and duplicates
```SQL
-----------------DATA CLEANING AND TRANSFORMATION------------------
---- Check the distinct ID in each table

SELECT COUNT(DISTINCT(Id)) 
	FROM BellaBeat.dbo.DailyActivity
	-- 33
SELECT COUNT(DISTINCT(Id)) 
	FROM BellaBeat.dbo.DailyCalories
	-- 33
SELECT COUNT(DISTINCT(Id)) 
	FROM BellaBeat.dbo.DailyIntensities
	-- 33
SELECT COUNT(DISTINCT(Id)) 
	FROM BellaBeat.dbo.DailySteps
	-- 33
SELECT COUNT(DISTINCT(Id)) 
	FROM BellaBeat.dbo.SleepDay
	-- 24

SELECT COUNT(DISTINCT(Id)) 
	FROM BellaBeat.dbo.WeightLog
	-- 8
GO

---- Check if the Id and date of DailyCalories, DailyIntensities, DailySteps are the same with the Id in DailyActivity
-- Check DailyCalories:
SELECT BellaBeat.dbo.DailyCalories.Calories, BellaBeat.dbo.DailyActivity.Calories
	FROM BellaBeat.dbo.DailyActivity
	INNER JOIN BellaBeat.dbo.DailyCalories
	ON BellaBeat.dbo.DailyActivity.Id=BellaBeat.dbo.DailyCalories.Id AND BellaBeat.dbo.DailyActivity.ActivityDate=BellaBeat.dbo.DailyCalories.ActivityDay

-- Check DailyIntensities:
SELECT BellaBeat.dbo.DailyIntensities.SedentaryMinutes, BellaBeat.dbo.DailyActivity.SedentaryMinutes
	FROM BellaBeat.dbo.DailyActivity
	INNER JOIN BellaBeat.dbo.DailyIntensities
	ON BellaBeat.dbo.DailyActivity.Id=BellaBeat.dbo.DailyIntensities.Id AND BellaBeat.dbo.DailyActivity.ActivityDate=BellaBeat.dbo.DailyIntensities.ActivityDay

-- Check DailySteps:
SELECT BellaBeat.dbo.DailyIntensities.SedentaryMinutes, BellaBeat.dbo.DailyActivity.SedentaryMinutes
	FROM BellaBeat.dbo.DailyActivity
	INNER JOIN BellaBeat.dbo.DailyIntensities
	ON BellaBeat.dbo.DailyActivity.Id=BellaBeat.dbo.DailyIntensities.Id AND BellaBeat.dbo.DailyActivity.ActivityDate=BellaBeat.dbo.DailyIntensities.ActivityDay	
GO

-- Formatted date column into YYYY/MM/DD date format in Daly.Activity table
ALTER TABLE BellaBeat.dbo.DailyActivity
	ADD Date DATE
UPDATE BellaBeat.dbo.DailyActivity
	SET Date=CONVERT(DATE,ActivityDate,101)
ALTER TABLE BellaBeat.dbo.DailyActivity
	DROP COLUMN ActivityDate
GO

-- Formatted all numerical data into FLOAT in Daly.Activity table
ALTER TABLE BellaBeat.dbo.DailyActivity
	ALTER COLUMN Id FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity
	ALTER COLUMN TotalSteps INT
ALTER TABLE BellaBeat.dbo.DailyActivity
	ALTER COLUMN TotalDistance FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN TrackerDistance FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity
	ALTER COLUMN LoggedActivitiesDistance FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN VeryActiveDistance	FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN ModeratelyActiveDistance FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN LightActiveDistance FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN SedentaryActiveDistance FLOAT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN VeryActiveMinutes INT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN FairlyActiveMinutes INT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN LightlyActiveMinutes INT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN SedentaryMinutes INT
ALTER TABLE BellaBeat.dbo.DailyActivity	
	ALTER COLUMN Calories INT
GO

-- Separate SleepDay column into Date and Hour columns in SleepDay table
ALTER TABLE BellaBeat.dbo.SleepDay
	ADD Date DATE
UPDATE BellaBeat.dbo.SleepDay
	SET Date=CONVERT(DATE,SleepDay,101)

ALTER TABLE BellaBeat.dbo.SleepDay
	ADD Time TIME
UPDATE BellaBeat.dbo.SleepDay
	SET Time=RIGHT(SleepDay,LEN(SleepDay)- CHARINDEX(' ', SleepDay + ' '))

ALTER TABLE BellaBeat.dbo.SleepDay
	DROP COLUMN SleepDay
GO

-- Separate SleepDay column into Date and Hour columns in WeightLog table
ALTER TABLE BellaBeat.dbo.WeightLog
	ADD Day DATE
UPDATE BellaBeat.dbo.WeightLog
	SET Day=CONVERT(DATE,Date,101)

ALTER TABLE BellaBeat.dbo.WeightLog
	ADD Time TIME
UPDATE BellaBeat.dbo.WeightLog
	SET Time=CONVERT(TIME, Date)

ALTER TABLE BellaBeat.dbo.WeightLog
	DROP COLUMN Date
GO

-- Find duplicates           
SELECT
	Id, 
	Date,
	COUNT(*) AS num_of_id
FROM BellaBeat.dbo.DailyActivity
GROUP BY
	Id,
	Date  --- No duplicate found

SELECT
	Id, 
	Date,
	COUNT(*) AS num_of_id
FROM BellaBeat.dbo.SleepDay
GROUP BY
	Id,
	Date -- 3 duplicates found

SELECT
	Id, 
	Day,
	COUNT(*) AS num_of_id
FROM BellaBeat.dbo.WeightLog
GROUP BY
	Id,
	Day -- No duplicate found

-- Remove duplicates in table SleepDay 

WITH CTE AS(
	SELECT Id,
	ROW_NUMBER() OVER(PARTITION BY Id ORDER BY(SELECT NULL)) AS RowNum
	FROM BellaBeat.dbo.SleepDay
)
DELETE FROM CTE WHERE RowNum > 1
GO

--Recheck if there is still duplicate in table SleepDay
SELECT
	Id, 
	Date,
	COUNT(*) AS num_of_id
FROM BellaBeat.dbo.SleepDay
GROUP BY
	Id,
	Date
GO -- No duplicate found

-- Check for missing Ids in the 3 tables
SELECT * FROM BellaBeat.dbo.DailyActivity
WHERE Id IS NULL 

SELECT * FROM BellaBeat.dbo.WeightLog
WHERE Id IS NULL
GO -- There is no NULL value in the 3 tables
```
## ANALYZING
Transform the data to identify patterns and draw conclusions. As determined by the Process step, I have a variety of data tables that measures different fitness parameters (steps, calories, distance, sleep, activity, etc). However, for organizational consistency as well as ease and simplicity, I will perform analysis on the data tables by whether observations are provided at a daily intervals. This is made possible because the “Id” column is a shared key that corresponds between each of the data tables.
In this process, I organized and formatted the data, performed some calculations, and identified trends as well as relationships between each variable.
```SQL
SELECT Id,
MIN(TotalSteps) AS Min_Total_Steps,
MAX(TotalSteps) AS Max_Total_Steps, 
AVG(TotalSteps) AS Avg_Total_Stpes,
MIN(TotalDistance) AS Min_Total_Distance, 
MAX(TotalDistance) AS Max_Total_Distance, 
AVG(TotalDistance) AS Avg_Total_Distance,
MIN(Calories) AS Min_Total_Calories,
MAX(Calories) AS Max_Total_Calories,
AVG(Calories) AS Avg_Total_Calories,
MIN(VeryActiveMinutes) AS Min_Very_Active_Minutes,
MAX(VeryActiveMinutes) AS Max_Very_Active_Minutes,
AVG(VeryActiveMinutes) AS Avg_Very_Active_Minutes,
MIN(FairlyActiveMinutes) AS Min_Fairly_Active_Minutes,
MAX(FairlyActiveMinutes) AS Max_Fairly_Active_Minutes,
AVG(FairlyActiveMinutes) AS Avg_Fairly_Active_Minutes,
MIN(LightlyActiveMinutes) AS Min_Lightly_Active_Minutes,
MAX(LightlyActiveMinutes) AS Max_Lightly_Active_Minutes,
AVG(LightlyActiveMinutes) AS Avg_Lightly_Active_Minutes,
MIN(SedentaryMinutes) AS Min_Sedentary_Minutes,
MAX(SedentaryMinutes) AS Max_Sedentary_Minutes,
AVG(SedentaryMinutes) AS Avg_Sedentary_Minutes
From BellaBeat.dbo.DailyActivity
Group BY Id
GO
```
![image](https://private-user-images.githubusercontent.com/152029040/294983941-ef314c17-3cee-45d0-9055-56671bec3a2d.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzUzNTAsIm5iZiI6MTcwNDczNTA1MCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTgzOTQxLWVmMzE0YzE3LTNjZWUtNDVkMC05MDU1LTU2NjcxYmVjM2EyZC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxNzMwNTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT01NDAyNDIzMjJhNWQ0NDUwNzYzOWVlYTU1ZDA3MGE2NTg5MDhhYzYwNDA4YjQ5Yjk2NmVjNWM1NzQ4ZGQ5ZTU1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.c8wqmGji6e85yxcRerh7NdVVM-qbVpcZC4I5ysguYDc)

```SQL
-- How often the users wear the Fitbit Fitness Tracker
SELECT Id, 
	COUNT(Id) AS TotalWearTime,
	FitBitUsageType = CASE
		WHEN COUNT(Id) >= 25 AND COUNT(Id)<=31 THEN 'Very Often Usage'
		WHEN COUNT(Id) >= 15 AND COUNT(Id)<=24 THEN 'Moderate Usage'
		WHEN COUNT(Id) >= 0 AND COUNT(Id) <=14 THEN 'Rare Usage'
		END
	FROM BellaBeat.dbo.DailyActivity
	GROUP BY Id
	ORDER BY TotalWearTime DESC
	GO
```
![image ](https://private-user-images.githubusercontent.com/152029040/294986390-6c68f66c-efae-439f-8555-54c80e28def3.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzU4MTEsIm5iZiI6MTcwNDczNTUxMSwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTg2MzkwLTZjNjhmNjZjLWVmYWUtNDM5Zi04NTU1LTU0YzgwZTI4ZGVmMy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxNzM4MzFaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0wZTFjM2E0OTFjODE1MTMyYmY3ZmQ4NmJkOTY1NzVmNzRlOTExYTZlZGJjM2M3YWVhOTU4MzM0NWQxZTc4MTU4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.mmeHbWO7aX6wlZitGBTDv9o-OXdy9UsKoxmSm19GnIc)

![image](https://private-user-images.githubusercontent.com/152029040/294986442-c7ad7235-7161-4250-a4a8-222e342eae08.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzU4NTQsIm5iZiI6MTcwNDczNTU1NCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTg2NDQyLWM3YWQ3MjM1LTcxNjEtNDI1MC1hNGE4LTIyMmUzNDJlYWUwOC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxNzM5MTRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hZmExZmQ3ZDU2OTI3ZjhjOWJhNzJiMjUyYzU1MThkNmQ3OWQ5YzE1OGU1NGNjMDllNjRmYWJlZTQ0NGMxMmIxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.bgM5JcftbkUStq9lGgC_QIBlCk-OX2Zrg4HZgROoQwY)


```SQL
-- How active the user based on the total steps they achieved
SELECT Id,
	AVG(TotalSteps) AS 'AverageTotalSteps',
	UserType = CASE
		WHEN AVG(TotalSteps) <5000 THEN 'Sedentary Lifestyle'
		WHEN AVG(TotalSteps) >=5000 AND AVG(TotalSteps) <= 7499 THEN 'Physically Inactive'
		WHEN AVG(TotalSteps) >=7500 AND AVG(TotalSteps) <= 9999 THEN 'Moderately Active'
		WHEN AVG(TotalSteps) >= 10000 AND AVG(TotalSteps) <= 12499 THEN 'Physically Active'
		WHEN AVG(TotalSteps) >= 12500 THEN 'Very Active'
		END
	FROM BellaBeat.dbo.DailyActivity
	GROUP BY Id
	ORDER BY AVG(TotalSteps) DESC
	GO
```
![image](https://private-user-images.githubusercontent.com/152029040/294988233-f60f97d5-9f2f-4d13-8f4b-30883efa7cef.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzYyODIsIm5iZiI6MTcwNDczNTk4MiwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTg4MjMzLWY2MGY5N2Q1LTlmMmYtNGQxMy04ZjRiLTMwODgzZWZhN2NlZi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxNzQ2MjJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kNWQxOTIyZGU0NGQ1NWI2ZGJkYjc1NmRkZmE4OTQ1OWZhZmEzNmM5Nzk4YzAwZmU3YzdiNTRjMDA3ODRiZThiJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.i7DGG6-LFeocrh2VCCUn6lOtLSiUfYVAOk1zHvm54X8)

![image](https://private-user-images.githubusercontent.com/152029040/294988515-c685ee1d-bef0-4321-a2f3-6db7bef115d7.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzYzMTEsIm5iZiI6MTcwNDczNjAxMSwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTg4NTE1LWM2ODVlZTFkLWJlZjAtNDMyMS1hMmYzLTZkYjdiZWYxMTVkNy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxNzQ2NTFaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hY2JkNWNmOWE5YjBkNWQzYzY3NzNjNjZjNDA4M2NjNjM3ZTBjZmM3OGE5YjU2Yzg4NGIwMzAwNzk2YzFhMzBhJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.m4o116LticX-e9NhSfQ5qWg8qgCzoY_oZYX6IKFgIxA)


```SQL
-- Add a new column in DailyActivity table to show the day of the week
ALTER TABLE BellaBeat.dbo.DailyActivity
ADD DayOfWeek NVARCHAR(50)

UPDATE BellaBeat.dbo.DailyActivity
SET DayOfWeek=DATENAME(weekday,Date)

-- Check the average active minutes by week day
SELECT DISTINCT(DayOfWeek),
	ROUND(AVG(VeryActiveMinutes),2) AS AvgVeryActiveMinutes,
	ROUND(AVG(FairlyActiveMinutes),2) AS AvgFairlyActiveMinutes,
	ROUND(AVG(LightlyActiveMinutes),2) AS AvgLightlyActiveMinutes,
	ROUND(AVG(SedentaryMinutes),2) AS AvgSedentaryMinutes
FROM BellaBeat.dbo.DailyActivity
GROUP BY DayOfWeek
GO
```
![image](https://private-user-images.githubusercontent.com/152029040/294989945-de678fa8-80ec-479b-ae63-e1c213330fb4.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzY0OTIsIm5iZiI6MTcwNDczNjE5MiwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTg5OTQ1LWRlNjc4ZmE4LTgwZWMtNDc5Yi1hZTYzLWUxYzIxMzMzMGZiNC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxNzQ5NTJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zZTQ3NzI2YzU4YjMzMDMwMzRmNjNmYzBmM2ZkYzdjNzY3NDA2YjA0ODEwZTE1NTRkMzYzMWU3YjY1MjM2YWI3JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.gtdsMESLlHbIfyVWU6ncxtUAdUXofs2WcyIjBslhJk0)

```SQL
-- Check which day users are most active and least active in walking 
SELECT DISTINCT(DayOfWeek),
	AVG(TotalSteps) AS AvgTotalSteps,
	ROUND(AVG(TotalDistance),2) AS AvgTotalDistance,
	AVG(Calories) AS AvgCalories
FROM BellaBeat.dbo.DailyActivity
GROUP BY DayOfWeek
GO
```
![image](https://private-user-images.githubusercontent.com/152029040/294990554-0d873140-a2b2-464e-86ad-6ed39c494273.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzY1ODUsIm5iZiI6MTcwNDczNjI4NSwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTkwNTU0LTBkODczMTQwLWEyYjItNDY0ZS04NmFkLTZlZDM5YzQ5NDI3My5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxNzUxMjVaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jNWRlMTA0ZjU3NTMzMDc3ZDVmMTVhODhkMjU0NTE5Y2FjYjM3ZTBlZTQyNWU2ZjFkMDY3ZmQ1MjBkMjhhNzc0JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.FWNECBfKxb7uSpzbs5hRWhwyTt_DX2kshuENVgNH26k)

```SQL
-- Check if walking more helps users sleep longer
-- Join DailyActivity table and SleepDay table using INNER JOIN
SELECT BellaBeat.dbo.DailyActivity.Id,
	AVG(BellaBeat.dbo.DailyActivity.Calories) As AvgCalories,
	AVG(BellaBeat.dbo.DailyActivity.TotalSteps) AS AvgTotalSteps,
	AVG(BellaBeat.dbo.SleepDay.TotalMinutesAsleep) AS AvgTotalMinutesAsleep
FROM BellaBeat.dbo.DailyActivity
INNER JOIN BellaBeat.dbo.SleepDay ON BellaBeat.dbo.DailyActivity.Id=BellaBeat.dbo.SleepDay.Id
GROUP BY BellaBeat.dbo.DailyActivity.Id
GO
```
![image](https://private-user-images.githubusercontent.com/152029040/294994480-701d75c9-641d-46e5-8ffa-dc1ad565450d.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzcyNjgsIm5iZiI6MTcwNDczNjk2OCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTk0NDgwLTcwMWQ3NWM5LTY0MWQtNDZlNS04ZmZhLWRjMWFkNTY1NDUwZC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxODAyNDhaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hNzg4YzExMzJkY2MxYWJlMWFmOWZmZmVhZmQ1ZjE5YmMxYzNmYzg0NmNlNmNjNTEzZjhiY2YwMmJhYTI2OGUzJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.tbCJ6HkWDaZaNRyChX5xnZlM82YUy0Zk-7p8b__NevU)
![image](https://private-user-images.githubusercontent.com/152029040/294994527-7e950db8-67c7-47cf-9ddf-b589c04426e2.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzcyOTQsIm5iZiI6MTcwNDczNjk5NCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTk0NTI3LTdlOTUwZGI4LTY3YzctNDdjZi05ZGRmLWI1ODljMDQ0MjZlMi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxODAzMTRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jMTA0OTM1M2QyMmQ1ODlhMWQ2ZGIyY2I3NDU4N2RiNDNkY2U2OWQ0Mzg2MTQwMDQ4NmVlYTU1MzY0OGI5MTYyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.G18SDD3Mr4Fg30U6lf2-2a73eM0hOtqLIjlMpWlWtLw)
![image](https://private-user-images.githubusercontent.com/152029040/294994567-7b8dc20a-0426-4ffb-af8e-247cd546f237.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MzczMTIsIm5iZiI6MTcwNDczNzAxMiwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTk0NTY3LTdiOGRjMjBhLTA0MjYtNGZmYi1hZjhlLTI0N2NkNTQ2ZjIzNy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxODAzMzJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yNjZiODk1NGNjNDcwNGZjNzM1M2E5NmRlNDdkYmM3MWNhODNjZDRhZTBlMzcyYmQzNzg0ZDU3ZjhiNzEzZTkyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.Vtg27pLCDkzVU_ynaC4zGOLF4MqDQgHd6yE0V6EwzrY)


```SQL
-- Indicate whether the user is overweight/underweight/healthy compared to BMI
SELECT Id,
	AVG(BMI) AS BMIIndex,
	Condition = CASE
		WHEN AVG(BMI)>24.9 THEN 'Overweight'
		WHEN AVG(BMI) < 18.5 THEN 'Underweight'
		ELSE 'Healthy'
		END
FROM BellaBeat.dbo.WeightLog
GROUP BY Id
GO
```
![image](https://private-user-images.githubusercontent.com/152029040/294995561-c180a435-343e-4dcd-810a-c4704457f121.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3Mzc1NTAsIm5iZiI6MTcwNDczNzI1MCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTk1NTYxLWMxODBhNDM1LTM0M2UtNGRjZC04MTBhLWM0NzA0NDU3ZjEyMS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxODA3MzBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT04OWNmZGYxYzFhNDAwY2MzZWRkODU2NGYzOTFlYWQ3NGY0MmRjMTYwMmIwYTY3ZDM4ZmFmY2VjZDQ5YTU0NTYyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.8cJmWcBVJjv-I9TA_wrMyqFJhZMsIPJBjqlqHZanBZ8)
![image](https://private-user-images.githubusercontent.com/152029040/294995602-baca62d0-31c2-4425-9350-0075a642b2cb.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3Mzc2MTQsIm5iZiI6MTcwNDczNzMxNCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTk1NjAyLWJhY2E2MmQwLTMxYzItNDQyNS05MzUwLTAwNzVhNjQyYjJjYi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxODA4MzRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05YTE4YWZmZjVlY2U3ZjgyYmM5MmRlY2UxOWE0NDc0YTM1YzE0NDFlZGI5NzczZTBjZjE2OTY1ZWY0OGNmMGNmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.N17oX3udpzi9kmmMSwxQ6bihQqFZijhKn9jQM8UjWpI)

<img src="[https://your-image-url.type](https://private-user-images.githubusercontent.com/152029040/294995602-baca62d0-31c2-4425-9350-0075a642b2cb.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3Mzc2MTQsIm5iZiI6MTcwNDczNzMxNCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTk1NjAyLWJhY2E2MmQwLTMxYzItNDQyNS05MzUwLTAwNzVhNjQyYjJjYi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxODA4MzRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05YTE4YWZmZjVlY2U3ZjgyYmM5MmRlY2UxOWE0NDc0YTM1YzE0NDFlZGI5NzczZTBjZjE2OTY1ZWY0OGNmMGNmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.N17oX3udpzi9kmmMSwxQ6bihQqFZijhKn9jQM8UjWpI)https://private-user-images.githubusercontent.com/152029040/294995602-baca62d0-31c2-4425-9350-0075a642b2cb.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3Mzc2MTQsIm5iZiI6MTcwNDczNzMxNCwicGF0aCI6Ii8xNTIwMjkwNDAvMjk0OTk1NjAyLWJhY2E2MmQwLTMxYzItNDQyNS05MzUwLTAwNzVhNjQyYjJjYi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMTA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDEwOFQxODA4MzRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05YTE4YWZmZjVlY2U3ZjgyYmM5MmRlY2UxOWE0NDc0YTM1YzE0NDFlZGI5NzczZTBjZjE2OTY1ZWY0OGNmMGNmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.N17oX3udpzi9kmmMSwxQ6bihQqFZijhKn9jQM8UjWpI" width="100" height="100">


