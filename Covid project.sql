SELECT *
FROM portafolioprojectcovid..covidD


--SELECT *
--FROM portafolioprojectcovid..covidV
--ORDER BY 5 DESC

--Data that i'll use

SELECT location, date, total_deaths, new_cases, population 
FROM portafolioprojectcovid..covidD
ORDER BY 1,2

-- Total cases vs Deaths in COLOMBIA

SELECT  location, date, total_deaths,  total_cases ,population,(total_deaths/total_cases)*100 as Deathpercentage
FROM portafolioprojectcovid..covidD
WHERE location = 'Colombia'
ORDER BY  2 DESC,3

--Cases vs population

SELECT  location, date,population, total_cases ,(total_cases/population)*100 as Cases_pertcentage
FROM portafolioprojectcovid..covidD
WHERE location = 'Colombia'
ORDER BY  1, 2

-- Countries with Highest Infection Rate compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portafolioprojectcovid..covidD
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From portafolioprojectcovid..covidD
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From portafolioprojectcovid..covidD
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(New_Cases)*100 as DeathPercentage
From portafolioprojectcovid..covidD
where continent is not null 
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CAST( v.new_vaccinations as float))  OVER ( Partition by d.location Order by d.location, d.date) AS Roollingpeoplevac
From portafolioprojectcovid..covidD d 
Join portafolioprojectcovid..covidV v 
On d.location = v.location
and d.date= v.date
where d.continent is not null 
order by 2,3 DESC