
USE perf_project;

-- ============================================================
-- 1. Drop existing normalized tables (child first → parent last)
-- ============================================================
DROP TABLE IF EXISTS employment_norm;
DROP TABLE IF EXISTS job_norm;
DROP TABLE IF EXISTS department_norm;
DROP TABLE IF EXISTS school_norm;
DROP TABLE IF EXISTS person_norm;


-- ============================================================
-- 2. Create normalized tables
-- ============================================================

-- 2.1 Person table
CREATE TABLE person_norm (
    PersonID   INT PRIMARY KEY,
    PersonName VARCHAR(255),
    BirthDate  VARCHAR(50)
);

-- 2.2 School table
CREATE TABLE school_norm (
    SchoolID     VARCHAR(50) PRIMARY KEY,
    SchoolName   VARCHAR(255),
    SchoolCampus VARCHAR(255)
);

-- 2.3 Department table
CREATE TABLE department_norm (
    DepartmentID   VARCHAR(50) PRIMARY KEY,
    DepartmentName VARCHAR(255),
    SchoolID       VARCHAR(50),
    FOREIGN KEY (SchoolID) REFERENCES school_norm(SchoolID)
);

-- 2.4 Job table
CREATE TABLE job_norm (
    JobID    VARCHAR(50) PRIMARY KEY,
    JobTitle VARCHAR(255)
);

-- 2.5 Employment fact table
CREATE TABLE employment_norm (
    RecordID     BIGINT AUTO_INCREMENT PRIMARY KEY,
    PersonID     INT,
    JobID        VARCHAR(50),
    DepartmentID VARCHAR(50),
    Earnings     DECIMAL(15,2),
    EarningsYear INT,
    StillWorking VARCHAR(5),

    FOREIGN KEY (PersonID)     REFERENCES person_norm(PersonID),
    FOREIGN KEY (JobID)        REFERENCES job_norm(JobID),
    FOREIGN KEY (DepartmentID) REFERENCES department_norm(DepartmentID)
);


-- ============================================================
-- 3. Populate normalized tables from employment_raw
-- ============================================================

-- Insert unique persons
INSERT IGNORE INTO person_norm (PersonID, PersonName, BirthDate)
SELECT DISTINCT PersonID, PersonName, BirthDate
FROM employment_raw;

-- Insert unique schools
INSERT IGNORE INTO school_norm (SchoolID, SchoolName, SchoolCampus)
SELECT DISTINCT SchoolID, SchoolName, SchoolCampus
FROM employment_raw;

-- Insert unique departments
INSERT IGNORE INTO department_norm (DepartmentID, DepartmentName, SchoolID)
SELECT DISTINCT DepartmentID, DepartmentName, SchoolID
FROM employment_raw;

-- Insert unique jobs
INSERT IGNORE INTO job_norm (JobID, JobTitle)
SELECT DISTINCT JobID, JobTitle
FROM employment_raw;

-- Insert employment records (fact table)
INSERT INTO employment_norm
(PersonID, JobID, DepartmentID, Earnings, EarningsYear, StillWorking)
SELECT PersonID, JobID, DepartmentID, Earnings, EarningsYear, StillWorking
FROM employment_raw;


-- ============================================================
-- 4. Validation checks (use for screenshots in report)
-- ============================================================
SELECT COUNT(*) AS raw_rows FROM employment_raw;
SELECT COUNT(*) AS people FROM person_norm;
SELECT COUNT(*) AS schools FROM school_norm;
SELECT COUNT(*) AS departments FROM department_norm;
SELECT COUNT(*) AS jobs FROM job_norm;
SELECT COUNT(*) AS employment_rows FROM employment_norm;


