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


-----------------DATA ANALYZING------------------
-- Check the summary of total steps, total distance, calories and activity level
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

-- Check which day users are most active and least active in walking 
SELECT DISTINCT(DayOfWeek),
	AVG(TotalSteps) AS AvgTotalSteps,
	ROUND(AVG(TotalDistance),2) AS AvgTotalDistance,
	AVG(Calories) AS AvgCalories
FROM BellaBeat.dbo.DailyActivity
GROUP BY DayOfWeek
GO

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

-- See whether there is correlation between the user weight and their active minutes
-- INNER JOIN DalyActivity table and WeightLog table
SELECT BellaBeat.dbo.DailyActivity.Id,
	(AVG(BellaBeat.dbo.DailyActivity.LightlyActiveMinutes)+AVG(BellaBeat.dbo.DailyActivity.FairlyActiveMinutes)+AVG(BellaBeat.dbo.DailyActivity.VeryActiveMinutes)) AS AVGTotalMinutes,
	AVG(BellaBeat.dbo.WeightLog.WeightKg) AS AVGWeight
FROM BellaBeat.dbo.DailyActivity
INNER JOIN BellaBeat.dbo.WeightLog ON BellaBeat.dbo.DailyActivity.Id=BellaBeat.dbo.WeightLog.Id
GROUP BY BellaBeat.dbo.DailyActivity.Id