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
