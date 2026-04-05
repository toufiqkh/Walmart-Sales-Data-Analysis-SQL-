
--Dropping DAY column--
ALTER TABLE [Data Set 01].[dbo].[WalmartSalesData.csv]
DROP COLUMN DAY

--Coverting all Float value to INT--
 UPDATE [Data Set 01].[dbo].[WalmartSalesData.csv]
SET Unit_price              = ROUND(Unit_price, 0),
    gross_income            = ROUND(gross_income, 0),
    Total                   = ROUND(Total, 0),
    cogs                    = ROUND(cogs, 0),
    Rating                  = ROUND(Rating, 0),
    gross_margin_percentage = ROUND(gross_margin_percentage, 0);


--Business Questions With Querry--
 
1--Unique Products--
SELECT DISTINCT Product_line
FROM [Data Set 01].[dbo].[WalmartSalesData.csv]


2--Duplicate records--
SELECT Invoice_ID, COUNT(*)
FROM dbo.[WalmartSalesData.csv]
GROUP BY Invoice_ID
HAVING COUNT(*) > 1;


3--second highest Income--
SELECT ROUND (MAX(gross_income),0) AS Second_Highest_Income
FROM dbo.[WalmartSalesData.csv]
WHERE gross_income < (SELECT MAX (gross_income)
FROM dbo.[WalmartSalesData.csv])


4--Total revenue per product--
SELECT Product_line, SUM(Total) AS TotalRevenue
FROM dbo.[WalmartSalesData.csv]
GROUP BY Product_line;


5--Top 3 highest-paid Customer--
SELECT TOP 3 ROUND (gross_income,0) AS Gross_Income,Customer_type,Payment,Gender,City
FROM dbo.[WalmartSalesData.csv]
ORDER BY gross_income DESC;


6--count of orders per Product with time--
SELECT Product_line, SHIFTS ,COUNT(*) AS OrderCount
FROM dbo.[WalmartSalesData.csv]
GROUP BY Product_line,SHIFTS;


7--Average order value per customer--
SELECT Customer_type,ROUND (AVG(gross_income),0) AS AvgOrderValue
FROM dbo.[WalmartSalesData.csv]
GROUP BY Customer_type;

8--Most selling product--
SELECT Product_line, Round (SUM(Total),0) AS TotalSold
FROM dbo.[WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY TotalSold DESC;


9--Total revenue and the number of orders per region--
SELECT City, SUM(Total) AS TotalRevenue, COUNT(Invoice_ID) AS OrderCount
FROM dbo.[WalmartSalesData.csv]
GROUP BY City;


10--customers placed more than 5 orders--
SELECT Customer_type, COUNT(*) AS OrderCount
FROM dbo.[WalmartSalesData.csv]
GROUP BY Customer_type
HAVING COUNT(*) > 5;


11--Orders Recived in the month March--
SELECT Customer_type, COUNT(*) AS OrderCount
FROM dbo.[WalmartSalesData.csv]
WHERE MONTH(Date) = 3
GROUP BY Customer_type;


12--Rank by Income with each Product Line--
SELECT  City, Product_line,Customer_type, Gender, gross_income,
RANK() OVER (PARTITION BY Product_line ORDER BY gross_income DESC) AS IncomeRank
FROM dbo.[WalmartSalesData.csv];


13--Departments with avg salary > company avg--
SELECT City, AVG(gross_income) AS CityAvgSalary
FROM dbo.[WalmartSalesData.csv]
GROUP BY City
HAVING AVG(gross_income) > (SELECT AVG(gross_income) FROM  dbo.[WalmartSalesData.csv]);

14--Gross Income between 25 and 30--
SELECT Product_line,Customer_type,gross_income
FROM dbo.[WalmartSalesData.csv]
WHERE gross_income between 25 and 30


15--Orders placed same City by same Product
SELECT City, Product_line, COUNT(*) AS OrdersCount
FROM dbo.[WalmartSalesData.csv]
GROUP BY City, Product_line
HAVING COUNT(*) > 1;


16--Average salary excluding highest & lowest--
SELECT AVG(gross_income) AS AvgIncome
FROM .[WalmartSalesData.csv]
WHERE gross_income NOT IN ((SELECT MAX(gross_income) 
FROM dbo.[WalmartSalesData.csv]), (SELECT MIN(gross_income) 
FROM dbo.[WalmartSalesData.csv]));


17--Top 1 Median income --
SELECT TOP 1 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_income) OVER ()  AS MedianIncome
FROM dbo.[WalmartSalesData.csv];


18--Orders with more than 3 unique products--
SELECT Product_line ,Count(*) as total
FROM dbo.[WalmartSalesData.csv]
Group  BY Product_line
HAVING COUNT (*) > 100;


19--First and last order dates by Product--
SELECT Product_line,
       MIN(Date) AS FirstOrder,
       MAX(Date) AS LastOrder
FROM dbo.[WalmartSalesData.csv]
GROUP BY Product_line;


20--Top 2 highest-selling products in each category--
SELECT *
FROM (SELECT Product_line, 
      SUM(cogs) AS TotalSold,
      RANK() OVER (ORDER BY SUM(cogs) DESC) AS RankInCategory
      FROM dbo.[WalmartSalesData.csv]
      GROUP BY Product_line
      ) t
      WHERE RankInCategory <= 2;


21--Percentage of total revenue OF each product--
SELECT Product_line,
SUM(gross_income) AS ProductRevenue,
ROUND(SUM(gross_income) * 100.0 / (SELECT SUM(gross_income) 
FROM dbo.[WalmartSalesData.csv]), 2) AS RevenuePercentage
FROM dbo.[WalmartSalesData.csv]
GROUP BY Product_line;


22-Average Rating by Gender--
SELECT Gender, AVG(Rating) AS AvgRating
FROM [Data Set 01].[dbo].[WalmartSalesData.csv]
GROUP BY Gender;
---------END-----------