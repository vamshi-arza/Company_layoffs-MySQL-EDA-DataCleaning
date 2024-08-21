# Company layoffs analysis using MySQL

### Project Objective
The goal of this project was to clean, standardize, and analyze layoffs data to gain insights into layoffs trends across different companies, industries, and countries. The analysis aimed to support decision-making by providing accurate, actionable insights from the dataset.

### Key Tasks and Procedures
#### 1. Data Preparation

- **Staging Table Creation** - Created layoffs_staging to replicate and work with the original layoffs data.

- **Data Duplication Handling** - Identified and removed duplicate records using SQL window functions.
Data Standardization

- **Cleaning** - Standardized text fields (e.g., trimming whitespace, consolidating industry names).

- **Formatting** - Converted date fields to a consistent DATE format and cleaned country names.

**2. Handling Null Values**

- **Identification and Cleanup** - Managed null or empty values in critical fields and updated or removed records as needed.

**3. Column Management:**

- **Removal** - Dropped unnecessary columns such as row_num post-cleanup.

**4. Exploratory Data Analysis (EDA):**

- **Summary Statistics** - Analyzed maximum and minimum values for key metrics.

- **Trend Analysis** - Examined layoffs over time, including rolling totals and annual comparisons.

**5. Advanced Analysis:**

- **Rolling Total Calculation** - Calculated monthly rolling totals to observe trends.

- **Company Rankings** - Ranked companies by layoffs and analyzed year-over-year data.
### Technologies Used:
- SQL for data manipulation and analysis.
- Data cleaning and transformation techniques.
- Exploratory analysis using SQL queries.
### Results and Insights:
- **Industry and Geographic Trends** - Identified significant layoffs patterns by industry and country.
- **Temporal Trends** - Mapped layoffs trends over time to identify patterns and anomalies.


