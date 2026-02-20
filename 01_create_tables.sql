-- ============================================================
-- Healthcare Data Analysis Dashboard
-- Database: HealthcareDB
-- Author: Madhurima Parui
-- ============================================================

CREATE DATABASE HealthcareDB;
GO
USE HealthcareDB;
GO

-- ============================================================
-- DIM TABLES (Star Schema)
-- ============================================================

CREATE TABLE dim_patient (
    patient_id       INT PRIMARY KEY IDENTITY(1,1),
    patient_name     NVARCHAR(100),
    age              INT,
    gender           NVARCHAR(10),
    blood_group      NVARCHAR(5),
    city             NVARCHAR(100),
    state            NVARCHAR(100),
    insurance_type   NVARCHAR(50)   -- 'Government', 'Private', 'None'
);

CREATE TABLE dim_department (
    department_id    INT PRIMARY KEY IDENTITY(1,1),
    department_name  NVARCHAR(100),
    floor_number     INT,
    head_doctor      NVARCHAR(100)
);

CREATE TABLE dim_doctor (
    doctor_id        INT PRIMARY KEY IDENTITY(1,1),
    doctor_name      NVARCHAR(100),
    specialization   NVARCHAR(100),
    department_id    INT FOREIGN KEY REFERENCES dim_department(department_id),
    years_experience INT
);

CREATE TABLE dim_medication (
    medication_id    INT PRIMARY KEY IDENTITY(1,1),
    medication_name  NVARCHAR(100),
    category         NVARCHAR(100),  -- 'Antibiotic', 'Painkiller', 'Cardiac', etc.
    unit_cost        DECIMAL(10,2)
);

CREATE TABLE dim_date (
    date_id          INT PRIMARY KEY,
    full_date        DATE,
    day              INT,
    month            INT,
    month_name       NVARCHAR(20),
    quarter          INT,
    year             INT,
    week_number      INT,
    day_name         NVARCHAR(20),
    is_weekend       BIT
);

-- ============================================================
-- FACT TABLE
-- ============================================================

CREATE TABLE fact_admissions (
    admission_id         INT PRIMARY KEY IDENTITY(1,1),
    patient_id           INT FOREIGN KEY REFERENCES dim_patient(patient_id),
    department_id        INT FOREIGN KEY REFERENCES dim_department(department_id),
    doctor_id            INT FOREIGN KEY REFERENCES dim_doctor(doctor_id),
    medication_id        INT FOREIGN KEY REFERENCES dim_medication(medication_id),
    admission_date_id    INT FOREIGN KEY REFERENCES dim_date(date_id),
    discharge_date_id    INT FOREIGN KEY REFERENCES dim_date(date_id),
    admission_type       NVARCHAR(50),   -- 'Emergency', 'Elective', 'Routine'
    length_of_stay       INT,            -- in days
    total_bill           DECIMAL(10,2),
    medication_cost      DECIMAL(10,2),
    outcome              NVARCHAR(50),   -- 'Recovered', 'Referred', 'Deceased'
    bed_number           INT,
    readmission_flag     BIT
);
GO
