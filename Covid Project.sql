-- Query 1: Retrieve all data from CovidDeaths table and order by continent and date
SELECT *
FROM Protfolio_Project..CovidDeaths
ORDER BY 3, 4;

-- Query 2: Select specific columns from CovidDeaths 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Query 3: Calculate death percentage for a specific country (Nigeria)
-- This shows the likelihood of dying if you contract COVID-19 in Nigeria
SELECT location, date, total_cases, total_deaths, 
       (total_deaths / total_cases) * 100 AS Death_Percentage
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
  AND location LIKE '%Nigeria%'
ORDER BY 1, 2;

-- Query 4: Calculate percentage of population infected
-- This shows what percentage of the population contracted COVID-19 in the United States
SELECT location, date, population, total_cases, 
       (total_cases / population) * 100 AS Percentage_of_population_infected
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
  AND location LIKE '%States%'
ORDER BY 1, 2;

-- Query 5: Show percentage of the population infected for all countries
SELECT location, date, population, total_cases, 
       (total_cases / population) * 100 AS Percentage_of_population_infected
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Query 6: Identify countries with the highest infection rates compared to population
SELECT location, population, 
       MAX(total_cases) AS Highest_Infection_count, 
       MAX((total_cases / population)) * 100 AS Percentage_of_population_infected
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Percentage_of_population_infected DESC;

-- Query 7: Show countries with the highest death count
SELECT location, MAX(CAST(total_deaths AS INT)) AS Total_Death_count
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_count DESC;

-- Query 8: Calculate total deaths in Nigeria
SELECT location, MAX(CAST(total_deaths AS INT)) AS Total_Death
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL 
  AND location LIKE '%Nigeria%'
GROUP BY location
ORDER BY Total_Death DESC;

-- Query 9: Calculate death count by continent
SELECT continent, MAX(CAST(total_deaths AS INT)) AS Total_Death
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death DESC;

-- Query 10: Calculate global totals for cases, deaths, and death percentage
SELECT SUM(new_cases) AS Total_cases, 
       SUM(CONVERT(INT, new_deaths)) AS Total_deaths, 
       (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS Death_Percentage
FROM Protfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Query 11: Calculate rolling vaccinations per country
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
       SUM(CAST(vac.new_vaccinations AS INT)) 
       OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinates
FROM Protfolio_Project..CovidDeaths dea
JOIN Protfolio_Project..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

-- Query 12: Use a Common Table Expression (CTE) to calculate vaccination percentage
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CONVERT(INT, vac.new_vaccinations)) 
           OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM Protfolio_Project..CovidDeaths dea
    JOIN Protfolio_Project..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated / Population) * 100 AS Vaccination_Percentage
FROM PopvsVac;

-- Query 13: Use a temporary table to calculate vaccination percentage
CREATE TABLE #PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(INT, vac.new_vaccinations)) 
       OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM Protfolio_Project..CovidDeaths dea
JOIN Protfolio_Project..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

SELECT *, (RollingPeopleVaccinated / Population) * 100 AS Vaccination_Percentage
FROM #PercentPopulationVaccinated;

-- Query 14: Create a view to store vaccination data for visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(INT, vac.new_vaccinations)) 
       OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM Protfolio_Project..CovidDeaths dea
JOIN Protfolio_Project..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT * 
FROM PercentPopulationVaccinated;
