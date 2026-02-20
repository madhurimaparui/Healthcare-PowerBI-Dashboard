-- ============================================================
-- Stored Procedures for Power BI Data Load
-- ============================================================
USE HealthcareDB;
GO

-- 1. Monthly Admission Summary
CREATE OR ALTER PROCEDURE sp_monthly_admissions
AS
BEGIN
    SELECT
        d.year,
        d.month_name,
        d.month,
        d.quarter,
        dept.department_name,
        COUNT(f.admission_id)           AS total_admissions,
        AVG(f.length_of_stay)           AS avg_length_of_stay,
        SUM(f.total_bill)               AS total_revenue,
        SUM(f.medication_cost)          AS total_medication_cost,
        SUM(CASE WHEN f.readmission_flag = 1 THEN 1 ELSE 0 END) AS readmissions,
        SUM(CASE WHEN f.outcome = 'Deceased' THEN 1 ELSE 0 END)  AS deaths
    FROM fact_admissions f
    JOIN dim_date d       ON f.admission_date_id = d.date_id
    JOIN dim_department dept ON f.department_id = dept.department_id
    GROUP BY d.year, d.month_name, d.month, d.quarter, dept.department_name
    ORDER BY d.year, d.month;
END;
GO

-- 2. Patient Demographics Summary
CREATE OR ALTER PROCEDURE sp_patient_demographics
AS
BEGIN
    SELECT
        p.gender,
        p.blood_group,
        p.insurance_type,
        p.state,
        CASE
            WHEN p.age < 18 THEN '0-17'
            WHEN p.age BETWEEN 18 AND 35 THEN '18-35'
            WHEN p.age BETWEEN 36 AND 55 THEN '36-55'
            ELSE '55+'
        END AS age_group,
        COUNT(f.admission_id) AS total_admissions,
        AVG(f.total_bill)     AS avg_bill,
        AVG(f.length_of_stay) AS avg_stay
    FROM fact_admissions f
    JOIN dim_patient p ON f.patient_id = p.patient_id
    GROUP BY p.gender, p.blood_group, p.insurance_type, p.state,
             CASE WHEN p.age < 18 THEN '0-17'
                  WHEN p.age BETWEEN 18 AND 35 THEN '18-35'
                  WHEN p.age BETWEEN 36 AND 55 THEN '36-55'
                  ELSE '55+' END;
END;
GO

-- 3. Medication Usage
CREATE OR ALTER PROCEDURE sp_medication_usage
AS
BEGIN
    SELECT
        m.medication_name,
        m.category,
        m.unit_cost,
        dept.department_name,
        COUNT(f.admission_id)  AS times_prescribed,
        SUM(f.medication_cost) AS total_medication_revenue
    FROM fact_admissions f
    JOIN dim_medication m    ON f.medication_id = m.medication_id
    JOIN dim_department dept ON f.department_id = dept.department_id
    GROUP BY m.medication_name, m.category, m.unit_cost, dept.department_name
    ORDER BY times_prescribed DESC;
END;
GO

-- 4. Doctor Performance
CREATE OR ALTER PROCEDURE sp_doctor_performance
AS
BEGIN
    SELECT
        doc.doctor_name,
        doc.specialization,
        dept.department_name,
        COUNT(f.admission_id)           AS total_patients,
        AVG(f.length_of_stay)           AS avg_los,
        AVG(f.total_bill)               AS avg_bill,
        SUM(CASE WHEN f.outcome = 'Recovered' THEN 1 ELSE 0 END) AS recovered,
        SUM(CASE WHEN f.outcome = 'Deceased'  THEN 1 ELSE 0 END) AS deceased
    FROM fact_admissions f
    JOIN dim_doctor doc      ON f.doctor_id = doc.doctor_id
    JOIN dim_department dept ON f.department_id = dept.department_id
    GROUP BY doc.doctor_name, doc.specialization, dept.department_name;
END;
GO

-- 5. RLS View — filter by department (used in Power BI RLS)
CREATE OR ALTER VIEW vw_admissions_rls AS
SELECT
    f.*,
    p.patient_name, p.age, p.gender, p.state, p.insurance_type,
    dept.department_name,
    doc.doctor_name, doc.specialization,
    m.medication_name, m.category,
    ad.full_date AS admission_date,
    ad.year, ad.month_name, ad.quarter
FROM fact_admissions f
JOIN dim_patient    p    ON f.patient_id    = p.patient_id
JOIN dim_department dept ON f.department_id = dept.department_id
JOIN dim_doctor     doc  ON f.doctor_id     = doc.doctor_id
JOIN dim_medication m    ON f.medication_id = m.medication_id
JOIN dim_date       ad   ON f.admission_date_id = ad.date_id
WHERE dept.department_name = USERPRINCIPALNAME()
   OR IS_ROLEMEMBER('Admin') = 1;
GO
