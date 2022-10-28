
Select *
From portafolioprojectcovid..covidD
Where continent is not null 
and location like '%income%'
order by 3,4
-- Total cases vs Deaths in COLOMBIA

SELECT  location, CAST( date AS Date) as date, total_deaths,  total_cases ,population,(total_deaths/total_cases)*100 as Deathpercentage
FROM portafolioprojectcovid..covidD
WHERE location = 'Colombia'
and  date ='2022-10-17 00:00:00.000'
ORDER BY  2 DESC

--Cases vs population

SELECT  location,CAST( date AS Date) as date,population, total_cases ,(total_cases/population)*100 as Cases_pertcentage
FROM portafolioprojectcovid..covidD
WHERE location = 'Colombia'
and  date ='2022-10-17 00:00:00.000'
ORDER BY   2 DESC

-- Countries with Highest Infection Rate compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portafolioprojectcovid..covidD
Group by Location, Population
order by PercentPopulationInfected desc


--  Highest Death Count per Continent

Select Location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portafolioprojectcovid..covidD
Where continent is not null 
and location  in ( 'Africa', 'Asia', 'Europe', 'North America', 'Oceania', 'South America')
Group by Location
order by TotalDeathCount desc

-- Showing contintents with the highest death count per population

Select continent, SUM(cast(Total_deaths as bigint)) as TotalDeathCount
From portafolioprojectcovid..covidD
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(New_Cases)*100 as DeathPercentage
From portafolioprojectcovid..covidD
where continent is not null 
and location not in ('World', 'European Union', 'International', 'High income', 'Low income', 'Lower middle income', 'Upper middle income')
order by 1,2

-- Total Population vs Vaccinations

--MAX of Population that has recieved at least one Covid Vaccine per continent


Select  d.location, d.date, d.population
, MAX(v.total_vaccinations) as RollingPeopleVaccinated
From  portafolioprojectcovid..covidD d 
Join portafolioprojectcovid..covidV v
	On d.location = v.location
	and d.date = v.date
where  d.date ='2022-10-17 00:00:00.000'
and d.location  in ( 'Africa', 'Asia', 'Europe', 'North America', 'Oceania', 'South America','World')
group by d.continent, d.location, d.date, d.population
order by 1,2,3 DESC

-- Shows Percentage of Population that has recieved at least one Covid Vaccine in Colombia

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portafolioprojectcovid..covidD dea
Join portafolioprojectcovid..covidV vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
and dea.location = 'Colombia'

--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated, CAST( date AS Date) as date
From PopvsVac
where date ='2022-10-17 00:00:00.000'
order by 3 desc

--

Select location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portafolioprojectcovid..covidD
Group by Location, Population, date
order by PercentPopulationInfected desc