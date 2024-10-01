COVID-19 Data Analysis Project
Overview
This project analyzes COVID-19 data from various countries and continents, focusing on deaths, cases, and vaccinations. The primary aim is to understand the impact of the virus on different populations and to visualize trends over time. The analysis is performed using SQL queries on the PortfolioSql1 database, specifically on the CovidDeaths$ and CovidVaccinations$ tables.

Tables Used
CovidDeaths$: Contains data on COVID-19 related deaths.
CovidVaccinations$: Contains data on COVID-19 vaccinations.
Queries Overview
1. Data Retrieval
Initial queries retrieve relevant data, filtering out null continent values:

sql
Copy code
SELECT *
FROM PortfolioSql1..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3, 4;
2. Total Cases and Deaths
Analysis of total cases versus total deaths:

sql
Copy code
SELECT Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM PortfolioSql1..CovidDeaths$
WHERE Location LIKE '%anada' AND continent IS NOT NULL
ORDER BY 1, 2;
3. Infection Rate
Determining countries with the highest infection rates compared to their populations:

sql
Copy code
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, 
       MAX(total_cases / population) * 100 AS PercentPopulationInfected
FROM PortfolioSql1..CovidDeaths$
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;
4. Death Counts by Country and Continent
Queries to show the countries and continents with the highest death counts:

sql
Copy code
SELECT continent, MAX(CAST(total_Deaths AS INT)) AS TotalDeathCount
FROM PortfolioSql1..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY TotalDeathCount DESC;
5. Global Summary
Calculating global total cases and deaths with a safe handling of null values:

sql
Copy code
SELECT 
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    CASE 
        WHEN SUM(new_cases) = 0 THEN 0
        ELSE SUM(CAST(new_deaths AS INT)) * 100.0 / SUM(new_cases) 
    END AS DeathPercentage
FROM PortfolioSql1..CovidDeaths$;
6. Vaccination Analysis
Joining COVID deaths and vaccination data to analyze vaccination impact:

sql
Copy code
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(CONVERT(INT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM PortfolioSql1..CovidDeaths$ d
JOIN PortfolioSql1..CovidVaccinations$ v ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2, 3;
7. Temporary Table and View Creation
Creating a temporary table and a view for later analysis:

sql
Copy code
CREATE VIEW PercentPopulationVaccinated AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(CONVERT(INT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM PortfolioSql1..CovidDeaths$ d
JOIN PortfolioSql1..CovidVaccinations$ v ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL;
Conclusion
This SQL project provides valuable insights into the COVID-19 pandemic's impact, facilitating data-driven decision-making. The analysis highlights trends in case counts, death rates, and vaccination progress across different regions, making it a crucial resource for public health discussions and strategies.

Requirements
SQL Server to execute the queries.
Access to the PortfolioSql1 database.
Usage
Clone or download the repository.
Open your SQL Server management tool.
Execute the SQL queries in your database to analyze the COVID-19 data.
