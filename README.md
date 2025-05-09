# 🕵️‍♂️ CrimeScope

**CrimeScope** is a data-driven project that leverages SQL and PostgreSQL to analyze and visualize New York Police Department (NYPD) crime data. This project aims to uncover crime patterns, detect anomalies, and help policymakers or researchers make informed decisions with actionable insights.

## 📊 Project Overview

This project analyzes publicly available NYPD crime datasets to answer critical questions about crime distribution, frequency, and patterns across different boroughs, time periods, and crime categories.

## 🚀 Features

* SQL queries for deep-dive analysis of crime trends
* Normalized PostgreSQL schema to handle structured crime data
* Analysis of crime frequency by borough, year, time of day, and crime type
* Identification of high-crime hotspots and patterns over time

## ✅ Problems Solved

1. **Crime Trend Analysis**

   * Extracted year-over-year trends to show whether specific crimes (e.g., burglary, assault) are increasing or decreasing.
   * Identified seasonal spikes and monthly crime fluctuations.

2. **High-Crime Area Detection**

   * Highlighted boroughs and precincts with the highest crime rates using aggregate SQL queries.
   * Detected repeat-offense hotspots via location clustering.

3. **Crime Type Insights**

   * Grouped crimes by felony, misdemeanor, and violation to determine law enforcement focus areas.
   * Found correlations between crime types and their most frequent occurrence hours.

4. **Anomaly Detection**

   * Spotted abnormal crime patterns post-COVID using 2020–2022 data.
   * Detected outlier precincts with disproportionate spikes.

5. **Data Cleaning & Normalization**

   * Removed duplicates, null values, and standardized date formats.
   * Structured raw CSV data into clean, relational PostgreSQL tables.

## 🛠️ Tech Stack

* **SQL** – Querying and analysis
* **PostgreSQL** – Data storage and relational modeling

## ⚙️ How to Run

1. **Set Up PostgreSQL**
   Create a database and execute `create_tables.sql` to initialize schema.

2. **Import Data**
   Load the CSVs into their respective tables using a tool like pgAdmin or a Python script.

3. **Run Queries**
   Use `crime_analysis_queries.sql` to extract insights and generate reports.
   
## 📌 Future Enhancements

* Real-time crime alert system integration
* Machine learning models to predict future crime occurrences
* Geo-mapping using Leaflet.js or Folium for spatial analysis
* Dashboard deployment using Power BI Service or Streamlit

## 📎 Data Source

* [NYPD Crime Complaint Data](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i)
