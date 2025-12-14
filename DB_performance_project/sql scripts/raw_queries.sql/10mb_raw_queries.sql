-- ==================================================
-- RAW (non-normalized) queries on employment_raw
-- Measures execution time in SECONDS using NOW(6)
-- Run this after importing the CSV into employment_raw
-- ==================================================

USE perf_project;

-- -----------------------------
-- Q1: Unique PersonNames + BirthDates
-- -----------------------------
SET @start_time = NOW(6);

SELECT DISTINCT PersonName, BirthDate
FROM employment_raw;

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q1_seconds;


-- -----------------------------
-- Q2: Active workers + School + Campus
-- -----------------------------
SET @start_time = NOW(6);

SELECT DISTINCT PersonName, SchoolName, SchoolCampus
FROM employment_raw
WHERE StillWorking = 'yes';

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q2_seconds;


-- -----------------------------
-- Q3: Assistant Professors at UMass Dartmouth (active)
-- -----------------------------
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
) AS Q3_seconds;


-- -----------------------------
-- Q4: How many people work at each campus currently
--     (most recent year + actively working)
-- -----------------------------
SET @start_time = NOW(6);

SELECT SchoolCampus,
       COUNT(DISTINCT PersonID) AS NumPeople
FROM employment_raw
WHERE StillWorking = 'yes'
  AND EarningsYear = (SELECT MAX(EarningsYear) FROM employment_raw)
GROUP BY SchoolCampus;

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q4_seconds;


-- -----------------------------
-- Q5: Total earnings per person across all years
-- -----------------------------
SET @start_time = NOW(6);

SELECT PersonID, PersonName, SUM(Earnings) AS TotalEarnings
FROM employment_raw
GROUP BY PersonID, PersonName;

SELECT ROUND(
  TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6)) / 1000000,
  6
) AS Q5_seconds;