# 🏥 Healthcare Data Analysis Dashboard

**Power BI | SQL Server | Azure Data Factory | Azure DevOps CI/CD**

---

## 📌 Project Overview

An end-to-end healthcare Business Intelligence solution built to analyze patient admissions, demographics, medication usage, and clinical outcomes. Designed to support both operational decisions (bed management, staffing) and clinical decisions (treatment outcomes, readmission reduction).

---

## 🗂️ Repository Structure

```
Healthcare-PowerBI-Dashboard/
│
├── sql/
│   ├── 01_create_tables.sql         # Star schema DDL (fact + dim tables)
│   ├── 02_insert_data.sql           # Sample data inserts
│   └── 03_stored_procedures.sql     # SPs used by Power BI + RLS view
│
├── adf/
│   └── PL_Healthcare_Ingestion_Pipeline.json   # ADF pipeline (SQL Server → Azure SQL)
│
├── dax/
│   └── DAX_Measures.dax             # All DAX measures used in the report
│
├── cicd/
│   └── azure-pipelines.yml          # Azure DevOps pipeline: Dev → UAT → Prod
│
├── powerbi/
│   └── Healthcare_Dashboard.pbix    # Power BI report file (add your .pbix here)
│
└── README.md
```

---

## 🗃️ Data Model — Star Schema

```
                    dim_date
                       │
dim_patient ──── fact_admissions ──── dim_department
                       │                    │
                  dim_doctor           dim_medication
```

**Fact Table:** `fact_admissions` — one row per patient admission
**Dimension Tables:** `dim_patient`, `dim_department`, `dim_doctor`, `dim_medication`, `dim_date`

---

## 📊 Dashboard Pages & Visuals

### Page 1 — Executive Summary
| Visual | Purpose |
|--------|---------|
| Card KPIs (4) | Total Admissions, Total Revenue, Avg Length of Stay, Readmission Rate % |
| Line Chart | Monthly admission trend (2022–2024) |
| Clustered Bar Chart | Admissions by Department |
| Donut Chart | Patient outcome split (Recovered / Referred / Deceased) |
| Slicer | Year, Quarter, Department |

### Page 2 — Patient Demographics
| Visual | Purpose |
|--------|---------|
| Stacked Bar Chart | Admissions by Age Group & Gender |
| Donut Chart | Insurance type distribution (Government / Private / None) |
| Map Visual | Patient geographic distribution by State |
| Matrix | Age group vs Department admission count |
| Card KPI | Avg patient age, % Female, % Male |
| Slicer | State, Insurance Type, Blood Group |

### Page 3 — Department & Doctor Performance
| Visual | Purpose |
|--------|---------|
| Clustered Column Chart | Total admissions per department |
| Bar Chart | Top 10 doctors by patient count |
| Scatter Plot | Avg Bill vs Avg Length of Stay by Doctor |
| KPI Card | Recovery Rate %, Mortality Rate % |
| Table | Doctor performance table (patients, avg LOS, recovered, deceased) |
| Slicer | Department, Admission Type |

### Page 4 — Medication Analysis
| Visual | Purpose |
|--------|---------|
| Bar Chart | Top 10 most prescribed medications |
| Stacked Bar Chart | Medication category usage by department |
| Line Chart | Medication cost trend by month |
| Card KPI | Total Medication Cost, Medication Cost % of Total Bill |
| Donut Chart | Medication category split |
| Slicer | Medication Category, Department |

### Page 5 — Admission Trends & Forecasting
| Visual | Purpose |
|--------|---------|
| Line Chart with Forecast | Monthly admissions with 3-month forecast |
| Area Chart | Rolling 3-month admissions |
| Clustered Bar | Emergency vs Elective vs Routine admissions by month |
| Card KPI | YoY Growth %, Admissions YTD, Revenue YTD |
| Slicer | Admission Type, Year |

---

## ⚙️ ADF Pipeline — Data Ingestion Flow

```
On-Premise SQL Server (HealthcareDB)
        │
        │  [Self-Hosted Integration Runtime]
        ▼
Azure Data Factory Pipeline (PL_Healthcare_Ingestion_Pipeline)
        │
        ├── Lookup Last Run Timestamp (incremental load)
        ├── Copy dim_patient
        ├── Copy dim_department
        ├── Copy dim_doctor
        ├── Copy dim_medication
        ├── Copy dim_date
        ├── Copy fact_admissions (incremental — new records only)
        ├── Trigger Power BI Dataset Refresh (REST API)
        └── Update Control Table (timestamp)
        │
        ▼
Azure SQL Staging Database
        │
        ▼
Power BI Dataset (Scheduled Refresh — Daily 2:00 AM IST)
```

---

## 🔐 Row-Level Security (RLS)

RLS is enforced so that department heads only see their department's data.

| Role | Filter |
|------|--------|
| Admin | All data |
| Department Head | Only their department |
| Doctor | Only their own patients |

Applied via `vw_admissions_rls` view using `USERPRINCIPALNAME()`.

---

## 🚀 CI/CD Pipeline — Azure DevOps

Automated deployment across 3 environments:

```
Code Push to main branch
        │
        ▼
  [Stage 1] Validate — Check PBIX + SQL files
        │
        ▼
  [Stage 2] Deploy to DEV workspace (auto)
        │
        ▼
  [Stage 3] Deploy to UAT workspace (manual approval required)
        │
        ▼
  [Stage 4] Deploy to PRODUCTION workspace (manual approval required)
              + Trigger dataset refresh
              + Send notification
```

**Tools:** Azure DevOps, MicrosoftPowerBIMgmt PowerShell module, Service Principal authentication

---

## 🛠️ How to Set Up

1. Run `sql/01_create_tables.sql` on your SQL Server instance
2. Run `sql/02_insert_data.sql` to load sample data
3. Run `sql/03_stored_procedures.sql` to create stored procedures
4. Import `adf/PL_Healthcare_Ingestion_Pipeline.json` into your Azure Data Factory
5. Update linked service connection strings with your credentials
6. Open `powerbi/Healthcare_Dashboard.pbix` in Power BI Desktop
7. Update the SQL Server connection to point to your instance
8. Publish to Power BI Service and configure RLS roles
9. Set up Azure DevOps variable group `PowerBI-Credentials` with required secrets
10. Run `cicd/azure-pipelines.yml` to activate the CI/CD pipeline

---

## 👩‍💻 Author

**Madhurima Parui** — Power BI Developer | Data Analyst
📧 madhuriaparui@gmail.com | 🔗 [LinkedIn](https://linkedin.com/in/madhurima-parui-586b50189)
