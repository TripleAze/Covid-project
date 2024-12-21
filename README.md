# COVID-19 Data Analysis Project

## Overview
This project involves analyzing COVID-19 data across various countries and continents, focusing on key metrics such as cases, deaths, population, and vaccinations. By leveraging SQL queries, we perform insightful analysis to understand the impact of the pandemic and vaccination rates globally.

## Project Structure
This project contains several SQL queries that analyze COVID-19 data from two main datasets: **CovidDeaths** and **CovidVaccinations**. These queries aim to derive insights on:

- COVID-19 cases vs deaths
- COVID-19 cases vs population
- Vaccination rates vs population
- Global and country-specific metrics

## Key SQL Queries
The project includes the following key SQL queries:

### 1. **Basic Data Exploration**
```sql
select *
from Protfolio_Project..CovidDeaths
order by 3, 4
```

This query retrieves basic data from the `CovidDeaths` table ordered by date and location.

### 2. **Filtered Data**
```sql
select location, date, total_cases, new_cases, total_deaths, population
from Protfolio_Project..CovidDeaths
where continent is not null
order by 1, 2
```

This query retrieves data for locations with a non-null continent, focusing on the total cases, new cases, total deaths, and population.

### 3. **Case vs Deaths Analysis**
```sql
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From Protfolio_Project..CovidDeaths
where continent is not null
and location like '%Nigeria%'
order by 1, 2
```

This query calculates the death percentage for Nigeria based on the total cases and total deaths.

### 4. **Case vs Population**
```sql
select location, date, population, total_cases, (total_cases/population)*100 as Death_Percentage
From Protfolio_Project..CovidDeaths
where continent is not null
and location like '%States%'
order by 1, 2
```

This query calculates the percentage of the population that has contracted COVID-19 in the United States.

### 5. **Infection Rates**
```sql
select location, population, max(total_cases) as Highest_Infection_count , max((total_cases/population))*100 as Percentage_of_population_infected
From Protfolio_Project..CovidDeaths
where continent is not null
group by location, population
order by Percentage_of_population_infected desc
```

This query identifies countries with the highest infection rates compared to their population.

### 6. **Death Count Analysis**
```sql
select location, max( cast( total_deaths as int) )as Total_Death_count
From Protfolio_Project..CovidDeaths
where continent is not null 
group by location
order by Total_Death_count desc
```

This query ranks countries based on their total death count.

### 7. **Vaccination Data**
```sql
select dea.continent, dea.location, dea.date, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over(partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinates
From Protfolio_Project..CovidDeaths dea
join Protfolio_Project..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3
```

This query analyzes the vaccination rates over time and calculates the rolling total of vaccinated people by location.

### 8. **Using CTE and Temp Tables**
```sql
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Protfolio_Project..CovidDeaths dea
Join Protfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
```

This query uses Common Table Expressions (CTE) to calculate the vaccination rates per population, partitioned by location and ordered by date.

## Insights and Visualizations
The results of these queries will inform several key insights into the global impact of the COVID-19 pandemic and vaccination efforts. These insights can then be visualized using tools like Power BI or Excel to convey the data effectively.

## Setup and Requirements
1. SQL Server or compatible database to run the queries.
2. Access to the **CovidDeaths** and **CovidVaccinations** datasets.
3. SQL Management Studio (SSMS) or any SQL editor for executing queries.

## How to Run
1. Clone or download the repository.
2. Open the SQL file in your SQL editor.
3. Execute the queries to retrieve insights.

## Author
- ** Aliyu Atiku Abubakar 

## Links
www.linkedin.com/in/isthatabubakar007
https://github.com/TripleAze
