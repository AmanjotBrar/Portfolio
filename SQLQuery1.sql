Select * 
From PortfolioSql1..CovidDeaths$
where continent is not null
Order by 3,4


--Select * 
--From PortfolioSql1..CovidVaccinations$
--Order by 3,4

--Select Data that we are going to use

Select Location,date,total_cases,new_cases, total_deaths,population 
from PortfolioSql1..CovidDeaths$
Order by 1,2

--Looking at Total Cases Vs Total Deaths

Select Location,date,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioSql1..CovidDeaths$
where Location like '%anada'
where continent is not null
order by 1,2

--Looking at Total cases vs Population
--Shows percentage of Population who got covid

Select Location,date,Population, total_cases, total_deaths,(total_cases/ population)*100 CovidPositivePercentage
from PortfolioSql1..CovidDeaths$
where Location like '%anada'
order by 1,2

--Looking at countries with Highest Infection Rate compared to population

Select Location,Population, max(total_cases) as HighestInfectionCount, max(total_cases/ population)*100 
PercentPopulationInfected
from PortfolioSql1..CovidDeaths$
Group by Location,Population
order by PercentPopulationInfected desc

--Showing Countries with highest Death Count

Select Location, max(cast(total_Deaths as int)) as TotalDeathCount
from PortfolioSql1..CovidDeaths$
 where continent is not null
 Group by Location
order by TotalDeathCount desc

--Let break down by Continent

--Showing the continents with the highest death counts

Select continent, max(cast(total_Deaths as int)) as TotalDeathCount
from PortfolioSql1..CovidDeaths$
where continent is not  null
order by TotalDeathCount desc

--Global Numbers--query did not work because of null or o values in some columns which is why used case
Select Sum(new_cases) as total_cases, sum(cast(new_deaths as int)) 
as total_deaths,Sum(cast(new_deaths as int )/New_cases)* 100 DeathPercentage
from PortfolioSql1..CovidDeaths$

order by 1,2
SELECT 
    SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS INT)) AS total_deaths,
    CASE 
        WHEN SUM(new_cases) = 0 THEN 0
        ELSE SUM(CAST(new_deaths AS INT)) * 100.0 / SUM(new_cases) 
    END AS DeathPercentage
FROM PortfolioSql1..CovidDeaths$
ORDER BY  total_cases, total_deaths;

----Join vaccination and Death Table(date and death)----
Select * from PortfolioSql1..CovidDeaths$ d
Join PortfolioSql1..CovidVaccinations$ v
ON d.location =v.location
and d.date= v.date

--Looking at Total Population vs Vaccinations
Select d.continent,d.location,d.date,d.population,v.new_vaccinations
,sum(convert(int,v.new_vaccinations)) Over (partition by d.location order by d.location,d.date)
as RollingPeopleVaccinated
from PortfolioSql1..CovidDeaths$ d
Join PortfolioSql1..CovidVaccinations$ v
ON d.location =v.location
and d.date= v.date
where d.continent is not null
Order by 2,3

--use CTE
with PopvsVac(continent,Location,Date,Population,New_vaccinations,RollingPeopleVaccinated)
as
(
Select d.continent,d.location,d.date,d.population,v.new_vaccinations
,sum(convert(int,v.new_vaccinations)) Over (partition by d.location order by d.location,d.date)
as RollingPeopleVaccinated
from PortfolioSql1..CovidDeaths$ d
Join PortfolioSql1..CovidVaccinations$ v
ON d.location =v.location
and d.date= v.date
where d.continent is not null
)
select * , (RollingPeopleVaccinated/population)*100
from PopvsVac

---Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select d.continent,d.location,d.date,d.population,v.new_vaccinations
,sum(convert(int,v.new_vaccinations)) Over (partition by d.location order by d.location,d.date)
as RollingPeopleVaccinated
from PortfolioSql1..CovidDeaths$ d
Join PortfolioSql1..CovidVaccinations$ v
ON d.location =v.location
and d.date= v.date
where d.continent is not null

select * , (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--Creating view to store data for later visualizations---

Create View PercentPopulationVaccinated as
Select d.continent,d.location,d.date,d.population,v.new_vaccinations
,sum(convert(int,v.new_vaccinations)) Over (partition by d.location order by d.location,d.date)
as RollingPeopleVaccinated
from PortfolioSql1..CovidDeaths$ d
Join PortfolioSql1..CovidVaccinations$ v
ON d.location =v.location
and d.date= v.date
where d.continent is not null


Select * from PercentPopulationVaccinated


