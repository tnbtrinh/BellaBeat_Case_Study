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
<img width="1300" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/1d6e33b3-7ea5-4dc3-a356-7b0a7291a778">


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
<img width="267" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/02a4aa2d-6baa-4d47-89aa-a456e0bf4bab">

<img width="649" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/d0bdd7c4-18b1-46c0-9ae0-39528bcf6030">



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
<img width="277" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/554af166-b53e-45ef-a606-2e3f24a3368f">
<img width="699" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/3b8e5b74-9056-459f-abf1-b9ce20e95ee4">


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
<img width="764" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/1d40c67e-b7b7-4370-baee-3f3640c2a047">


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
<img width="1171" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/5009d231-b248-4496-9af2-209c868d3660">


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
<img width="363" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/26ea0318-7e7e-4d55-a2cd-70c2217f8ad7">
<img width="637" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/72210bc1-805c-495a-9251-5da2eda20d39">
<img width="624" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/f42dfa50-621b-4922-8de2-3e91f402e982">

As we can see, there is no correlation between walking and sleeping time

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
<img width="304" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/9a94a75b-6d7c-4359-9945-010320f8c79b">

<img width="568" alt="image" src="https://github.com/tnbtrinh/BellaBeat_Case_Study/assets/152029040/5d8c69d9-f4f7-4be4-a44d-b3a2ebb29969">

## CONCLUSION
- In a period of a month (April to May 2016), there was 88% of users in "Very Often Usage" when it came to how frequent they wear their Fitbit tracker
- Most of the users were not active, as sendentary minutes show the highest values
- Saturday and Tuesday made up to the most active day in walking
- There is no correlation between steps, calories burned and total minutes asleep
- There moe intense users workout, the better for them to have a better BMI index

## ACT
- Showcase the importance of doing sports activities daily, by highlighting the correlation between total active minutes vs healthy weight, so that users can have a better awareness of using the product more often to check the index
- Improve the notification feature of the tracker app as reminders for users to achieve their goal and increase total steps each day
- Provide reward voucher/redeem based on the total amount of steps reached daily/weekly to boost the workout



