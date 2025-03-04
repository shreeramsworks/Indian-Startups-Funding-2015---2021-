-- Create a new database called Startup_Fund
CREATE DATABASE Startup_Fund;

-- Use the Startup_Fund database
USE Startup_Fund;

-- Create a table called India with the specified columns
CREATE TABLE India (
    `Sr No` INT PRIMARY KEY,
    startup TEXT,
    vertical VARCHAR(50),
    city VARCHAR(50),
    investors TEXT,
    round TEXT,
    amount FLOAT,
    year INT,
    state VARCHAR(50)
);

-- Load data from a CSV file into the India table
LOAD DATA INFILE "C:\\Users\\shree\\Desktop\\projects\\Indian Startups Funding (2015 - 2021)\\Indian_startups_funding_Analyze.csv"
INTO TABLE India
FIELDS TERMINATED BY "," 
ENCLOSED BY '"' 
LINES TERMINATED BY "\n"
IGNORE 1 LINES;

-- Select all records from the India table
SELECT * FROM India;

-- Count the total number of records in the India table
SELECT COUNT(`Sr No`) FROM India; 

-- Select distinct verticals and count the number of records for each vertical, ordered by the count in descending order
SELECT DISTINCT(vertical), COUNT(`Sr No`) AS total FROM India
GROUP BY 1
ORDER BY 2 DESC;

-- Select cities and count the number of records for each city, ordered by the count in descending order
SELECT city, COUNT(`Sr No`) AS total FROM India
GROUP BY 1
ORDER BY 2 DESC;

-- Select investors and count the number of records for each investor, having count greater than 1, ordered by the count in descending order
SELECT investors, COUNT(investors) AS total FROM India
GROUP BY 1
HAVING total > 1
ORDER BY 2 DESC;

-- Select distinct rounds from the India table
SELECT DISTINCT(round) FROM India;

-- Select investors and calculate the average round count, limited to the top 3 investors, ordered by the average round count in descending order
SELECT investors, AVG(total) AS `avg round` FROM 
(SELECT investors, COUNT(round) AS total FROM India
GROUP BY 1) AS sub
GROUP BY 1
ORDER BY 1 DESC
LIMIT 3;

-- Calculate the total investment amount in crore from the India table
SELECT FLOOR(SUM(amount)) AS total_invest_in_cr FROM India;

-- Select verticals and calculate the total investment amount in crore for each vertical, limited to the top 3 verticals, ordered by the total investment in descending order
SELECT vertical, FLOOR(SUM(amount)) AS toatal_in_cr FROM India
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Select distinct years from the India table
SELECT DISTINCT(year) FROM India;

-- Select years and calculate the total investment amount in crore for each year, ordered by the total investment in descending order
SELECT year, FLOOR(SUM(amount)) AS investment_in_cr FROM India
GROUP BY 1
ORDER BY 2 DESC;

-- Select verticals, years, and calculate the total investment amount in crore, ordered by the total investment in descending order
SELECT vertical, year, FLOOR(SUM(amount)) AS total_Innvest_cr FROM India
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Select verticals, years, and total investment amount in crore for the top 3 verticals in each year, ordered by year and rank
WITH ranked AS (
    SELECT vertical, year, FLOOR(SUM(amount)) AS total, ROW_NUMBER() OVER (PARTITION BY year ORDER BY FLOOR(SUM(amount)) DESC) AS num FROM India
    GROUP BY 1, 2
)
SELECT vertical, year, total FROM ranked
WHERE num <= 3
ORDER BY year, num;

-- Select investors, years, startups, and total investment amount in crore for the top 3 investors in each year, ordered by year and rank
WITH invrank AS (
    SELECT investors, year, startup, FLOOR(SUM(amount)) AS total_in_cr, ROW_NUMBER() OVER (PARTITION BY year ORDER BY FLOOR(SUM(amount)) DESC) AS num FROM India
    GROUP BY 1, 2, 3
)
SELECT investors, year, startup, total_in_cr, num FROM invrank
WHERE num <= 3
ORDER BY year, num;

-- Select startups, years, and calculate the total investment amount in crore, limited to the top 3 startups, ordered by the total investment in descending order
SELECT startup, year, FLOOR(SUM(amount)) AS total FROM India
GROUP