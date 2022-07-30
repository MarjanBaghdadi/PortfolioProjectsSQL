--putting all three tables into one
SELECT *
FROM dbo.['2018$']
union
SELECT *
FROM dbo.['2019$']
union
SELECT *
FROM dbo.['2020$']


--Exploring the data
with hotels as (
SELECT *
FROM dbo.['2018$']
union
SELECT *
FROM dbo.['2019$']
union
SELECT *
FROM dbo.['2020$'])
--Hypothesis: is the hotel revenue growing by year?
SELECT
arrival_date_year,
ROUND(SUM((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue 
FROM hotels
GROUP BY arrival_date_year

--showing the revenue by hotel type per eyar as well:
with hotels as (
SELECT *
FROM dbo.['2018$']
union
SELECT *
FROM dbo.['2019$']
union
SELECT *
FROM dbo.['2020$'])
 
SELECT
arrival_date_year, hotel,
ROUND(SUM((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue 
FROM hotels
GROUP BY arrival_date_year, hotel


SELECT *
FROM dbo.market_segment$
-- Joining the market_segment table with the main tables:

with hotels as (
SELECT *
FROM dbo.['2018$']
union
SELECT *
FROM dbo.['2019$']
union
SELECT *
FROM dbo.['2020$'])
 
SELECT * FROM hotels
LEFT JOIN dbo.market_segment$
ON hotels.market_segment = market_segment$.market_segment
LEFT JOIN dbo.meal_cost$ 
ON meal_cost$.meal = hotels.meal
