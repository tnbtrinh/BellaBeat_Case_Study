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
Go -- No duplicate found

-- Check for missing Ids in the 3 tables
SELECT * FROM BellaBeat.dbo.DailyActivity
WHERE Id IS NULL 

SELECT * FROM BellaBeat.dbo.WeightLog
WHERE Id IS NULL
GO -- There is no NULL value in the 3 tables
```
## ANALYZING
