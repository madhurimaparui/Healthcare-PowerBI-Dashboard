-- ============================================================
-- Sample Data Inserts — HealthcareDB
-- ============================================================
USE HealthcareDB;
GO

-- dim_department
INSERT INTO dim_department (department_name, floor_number, head_doctor) VALUES
('Cardiology', 3, 'Dr. Rajesh Mehta'),
('Neurology', 4, 'Dr. Priya Sharma'),
('Orthopedics', 2, 'Dr. Anil Gupta'),
('Oncology', 5, 'Dr. Sunita Rao'),
('General Medicine', 1, 'Dr. Vikram Das'),
('Pediatrics', 2, 'Dr. Meena Joshi'),
('Emergency', 1, 'Dr. Sameer Khan'),
('Gynecology', 3, 'Dr. Rekha Pillai');

-- dim_doctor
INSERT INTO dim_doctor (doctor_name, specialization, department_id, years_experience) VALUES
('Dr. Rajesh Mehta',    'Cardiologist',        1, 15),
('Dr. Priya Sharma',    'Neurologist',         2, 12),
('Dr. Anil Gupta',      'Orthopedic Surgeon',  3, 10),
('Dr. Sunita Rao',      'Oncologist',          4, 18),
('Dr. Vikram Das',      'General Physician',   5, 8),
('Dr. Meena Joshi',     'Pediatrician',        6, 11),
('Dr. Sameer Khan',     'Emergency Physician', 7, 6),
('Dr. Rekha Pillai',    'Gynecologist',        8, 14),
('Dr. Arjun Nair',      'Cardiologist',        1, 9),
('Dr. Deepa Iyer',      'Neurologist',         2, 7);

-- dim_patient
INSERT INTO dim_patient (patient_name, age, gender, blood_group, city, state, insurance_type) VALUES
('Ravi Kumar',       45, 'Male',   'B+',  'Kolkata',   'West Bengal',  'Private'),
('Anita Dey',        32, 'Female', 'O+',  'Mumbai',    'Maharashtra',  'Government'),
('Suresh Patil',     60, 'Male',   'A+',  'Pune',      'Maharashtra',  'None'),
('Kavya Reddy',      28, 'Female', 'AB+', 'Hyderabad', 'Telangana',    'Private'),
('Mohan Lal',        55, 'Male',   'O-',  'Delhi',     'Delhi',        'Government'),
('Sunita Ghosh',     40, 'Female', 'B-',  'Kolkata',   'West Bengal',  'Private'),
('Ramesh Verma',     70, 'Male',   'A-',  'Agra',      'Uttar Pradesh','None'),
('Pooja Singh',      25, 'Female', 'O+',  'Lucknow',   'Uttar Pradesh','Government'),
('Arjun Das',        50, 'Male',   'B+',  'Chennai',   'Tamil Nadu',   'Private'),
('Nisha Jain',       35, 'Female', 'AB-', 'Jaipur',    'Rajasthan',    'None'),
('Deepak Sharma',    48, 'Male',   'O+',  'Bangalore', 'Karnataka',    'Private'),
('Meera Pillai',     29, 'Female', 'A+',  'Kochi',     'Kerala',       'Government'),
('Vijay Nair',       63, 'Male',   'B+',  'Kolkata',   'West Bengal',  'None'),
('Sonal Mehta',      37, 'Female', 'O-',  'Ahmedabad', 'Gujarat',      'Private'),
('Ashok Tiwari',     52, 'Male',   'A+',  'Patna',     'Bihar',        'Government');

-- dim_medication
INSERT INTO dim_medication (medication_name, category, unit_cost) VALUES
('Aspirin',        'Cardiac',      5.50),
('Metformin',      'Diabetes',     8.00),
('Amoxicillin',    'Antibiotic',  12.00),
('Paracetamol',    'Painkiller',   3.00),
('Atorvastatin',   'Cardiac',     15.00),
('Ibuprofen',      'Painkiller',   6.00),
('Omeprazole',     'Gastro',       9.00),
('Amlodipine',     'Cardiac',     11.00),
('Ciprofloxacin',  'Antibiotic',  18.00),
('Insulin',        'Diabetes',    45.00);

-- dim_date (2022–2024)
DECLARE @date DATE = '2022-01-01';
WHILE @date <= '2024-12-31'
BEGIN
    INSERT INTO dim_date VALUES (
        CONVERT(INT, FORMAT(@date,'yyyyMMdd')),
        @date,
        DAY(@date),
        MONTH(@date),
        DATENAME(MONTH, @date),
        DATEPART(QUARTER, @date),
        YEAR(@date),
        DATEPART(WEEK, @date),
        DATENAME(WEEKDAY, @date),
        CASE WHEN DATEPART(WEEKDAY,@date) IN (1,7) THEN 1 ELSE 0 END
    );
    SET @date = DATEADD(DAY, 1, @date);
END;
GO

-- fact_admissions
INSERT INTO fact_admissions (patient_id, department_id, doctor_id, medication_id, admission_date_id, discharge_date_id, admission_type, length_of_stay, total_bill, medication_cost, outcome, bed_number, readmission_flag) VALUES
(1,  1, 1,  1,  20220115, 20220120, 'Emergency',  5,  45000, 550,  'Recovered', 101, 0),
(2,  2, 2,  3,  20220210, 20220218, 'Elective',   8,  72000, 960,  'Recovered', 204, 0),
(3,  3, 3,  6,  20220305, 20220312, 'Routine',    7,  55000, 420,  'Recovered', 302, 0),
(4,  4, 4,  9,  20220420, 20220505, 'Elective',  15,  95000,2700,  'Referred',  401, 1),
(5,  5, 5,  4,  20220515, 20220517, 'Emergency',  2,  18000, 600,  'Recovered', 105, 0),
(6,  1, 9,  5,  20220601, 20220608, 'Routine',    7,  63000,1050,  'Recovered', 102, 0),
(7,  7, 7,  4,  20220710, 20220711, 'Emergency',  1,  12000, 300,  'Recovered', 701, 0),
(8,  6, 6,  3,  20220815, 20220820, 'Elective',   5,  32000, 600,  'Recovered', 601, 0),
(9,  2, 10, 2,  20220905, 20220915, 'Routine',   10,  88000, 800,  'Recovered', 205, 1),
(10, 8, 8,  7,  20221010, 20221015, 'Elective',   5,  41000, 450,  'Recovered', 801, 0),
(11, 1, 1,  8,  20221115, 20221122, 'Emergency',  7,  67000,1100,  'Recovered', 103, 0),
(12, 4, 4,  9,  20221201, 20221220, 'Elective',  19, 110000,3420,  'Deceased',  402, 0),
(13, 3, 3,  6,  20230115, 20230122, 'Routine',    7,  58000, 420,  'Recovered', 303, 0),
(14, 5, 5,  4,  20230210, 20230212, 'Emergency',  2,  21000, 600,  'Recovered', 106, 1),
(15, 2, 2,  3,  20230320, 20230330, 'Elective',  10,  79000, 960,  'Recovered', 206, 0),
(1,  1, 9,  1,  20230410, 20230415, 'Routine',    5,  47000, 550,  'Recovered', 104, 1),
(3,  7, 7,  4,  20230501, 20230502, 'Emergency',  1,  13000, 300,  'Recovered', 702, 0),
(5,  5, 5,  2,  20230612, 20230618, 'Routine',    6,  39000, 800,  'Recovered', 107, 0),
(7,  4, 4,  9,  20230720, 20230808, 'Elective',  19, 105000,3420,  'Referred',  403, 1),
(9,  1, 1,  8,  20230815, 20230822, 'Emergency',  7,  71000,1100,  'Recovered', 105, 0),
(11, 6, 6,  3,  20230910, 20230915, 'Elective',   5,  35000, 600,  'Recovered', 602, 0),
(13, 8, 8,  7,  20231005, 20231010, 'Routine',    5,  43000, 450,  'Recovered', 802, 0),
(2,  3, 3,  6,  20231110, 20231117, 'Elective',   7,  61000, 420,  'Recovered', 304, 0),
(4,  2, 10, 3,  20231201, 20231210, 'Routine',    9,  83000, 960,  'Recovered', 207, 0),
(6,  1, 1,  5,  20240115, 20240122, 'Emergency',  7,  69000,1050,  'Recovered', 106, 0),
(8,  4, 4,  9,  20240210, 20240228, 'Elective',  18, 108000,3420,  'Referred',  404, 1),
(10, 5, 5,  4,  20240305, 20240307, 'Emergency',  2,  19500, 600,  'Recovered', 108, 0),
(12, 7, 7,  4,  20240410, 20240411, 'Emergency',  1,  11500, 300,  'Recovered', 703, 0),
(14, 6, 6,  3,  20240515, 20240520, 'Elective',   5,  33000, 600,  'Recovered', 603, 0),
(15, 1, 9,  8,  20240620, 20240627, 'Routine',    7,  65000,1100,  'Recovered', 107, 0);
GO
