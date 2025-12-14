-- ==================================================
-- Database: perf_project
-- Table  : employment_raw
-- Description:
--   These queries are executed on the non-normalized
--   table directly imported from the CSV file.
--   Execution time is measured in SECONDS for
--   performance comparison.
-- ==================================================

USE perf_project;

----------------------------------------------------
-- Query 1
-- Here we List all unique person names along with their
-- birth dates.
-- DISTINCT is used because the same person may
-- appear multiple times due to different jobs ,or earnings years.
----------------------------------------------------
SET @start_time = NOW(6);
SELECT DISTINCT PersonName, BirthDate
FROM employment_raw;
SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q1_execution_time_seconds;


----------------------------------------------------
-- Query 2
-- List unique person names of people who are
-- currently working, along with the school name
-- and campus they are associated with.
-- The WHERE clause filters only active workers.
----------------------------------------------------
SET @start_time = NOW(6);

SELECT DISTINCT PersonName, SchoolName, SchoolCampus
FROM employment_raw
WHERE StillWorking = 'yes';

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q2_execution_time_seconds;


----------------------------------------------------
-- Query 3
-- Show the names and job titles of all Assistant
-- Professors currently working at the
-- University of Massachusetts Dartmouth.
-- Multiple conditions are applied to narrow
-- down the results.
----------------------------------------------------
SET @start_time = NOW(6);

SELECT DISTINCT PersonName, JobTitle
FROM employment_raw
WHERE StillWorking = 'yes'
  AND JobTitle = 'Assistant Professor'
  AND SchoolName = 'University of Massachusetts'
  AND SchoolCampus = 'Dartmouth';

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q3_execution_time_seconds;


----------------------------------------------------
-- Query 4
-- Show how many people are currently working at
-- each campus in the most recent earnings year.
-- A subquery is used to find the latest year,
-- and COUNT(DISTINCT PersonID) avoids double
-- counting the same person.
----------------------------------------------------
SET @start_time = NOW(6);

SELECT SchoolCampus,
       COUNT(DISTINCT PersonID) AS NumPeople
FROM employment_raw
WHERE StillWorking = 'yes'
  AND EarningsYear = (
      SELECT MAX(EarningsYear)
      FROM employment_raw
  )
GROUP BY SchoolCampus;

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q4_execution_time_seconds;


----------------------------------------------------
-- Query 5
-- Show the total earnings of each unique person
-- across all years.
-- SUM is used to aggregate earnings, and GROUP BY
-- combines multiple yearly records per person.
----------------------------------------------------
SET @start_time = NOW(6);

SELECT PersonID, PersonName, SUM(Earnings) AS TotalEarnings
FROM employment_raw
GROUP BY PersonID, PersonName;

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q5_execution_time_seconds;