# Los Angeles Crime Data Analysis (2020-2024)

## Overview
This project analyzes crime data in Los Angeles from **January 2020 to August 2024**. It explores crime trends, geographical hotspots, victim demographics, and temporal patterns, providing actionable insights for improving public safety and crime prevention.

### Key Features:
- **Data Cleaning:** Python was used for data preprocessing, including handling missing values, creating new columns, and transforming the dataset.
- **Data Analysis:** SQL was utilized to analyze the cleaned dataset and generate answers to specific crime-related questions.
- **Visualizations:** using PowerBI, The analysis was supported by visualizations highlighting key trends and insights.

---

## Tools Used
- **Python**: For data cleaning and feature engineering.
- **SQL**: For querying the cleaned dataset.
- **Jupyter Notebook**: To document and run Python code.
- **MS PowerBI**: For visualizations .
- **Pandas**: For data manipulation.

---

# Findings

### Top Crime Trends
- **Vehicle Theft** was the most prevalent crime, peaking in 2022 with 24,739 cases.  
- **Identity Theft** showed a sharp rise in 2022, reaching 22,113 cases.

### Geographical Hotspots
- **Central Division** reported the highest crime rate with 67,095 incidents.

### Victim Demographics
- **Adults (18-50)** were the most affected group, with 520,282 cases.  
- Women were particularly vulnerable to **Intimate Partner Assaults** and **Identity Theft**.

### Temporal Patterns
- Crime rates were higher **during the daytime** and on **Fridays**.

---

# Files in the Repository

- **`LA_Crime_Cleaning.ipynb`**:  
  The Jupyter Notebook that shows the data cleaning process, including handling missing data, feature creation, and saving the cleaned dataset.

- **`LA_Crime_Analysis.sql`**:  
  SQL queries used to analyze the cleaned data. The queries address questions such as:
  - Crime trends by year.
  - Areas with the highest and lowest crime rates.
  - Victim demographics by age and sex.

- **`Report.md`**:  
  A detailed report summarizing the findings, including key insights and policy recommendations.

- **`visuals/`**:  
  Folder with visualizations (e.g., `crime_trends.pdf`).