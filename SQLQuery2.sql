--Select * 
--from PortfolioProject.dbo.CovidDeaths
--order by 3,4

--Select * from PortfolioProject..CovidVaccinations
--order by 3,4

-- looking at Deaath Percentage by different methods

Select Location,date, total_cases, new_cases, total_deaths,population
from PortfolioProject.dbo.CovidDeaths
order by 1,2


Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
order by 1,2

Select Location,date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DP
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2

-- Looking at Total cases vs Population

Select Location,date,population, total_cases, (cast(total_cases as float)/cast(population as float))*100 as  DP
from PortfolioProject..CovidDeaths
--where location like 'India'
order by 1,2



-- Looking at countries at highest Infection rates vs Population

Select Location,population, Max(total_cases),    MAX((cast(total_cases as float)/cast(population as float)))*100 as  InfectedPopulation
from PortfolioProject..CovidDeaths
where population > '1000000'
group by Location,population
order by InfectedPopulation desc

--Showing Countries with highest death count

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by Location
order by TotalDeathCount desc

-- Looking in Continent View

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

-- showing the continentswith highest death counts

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as Int)) as totaldeaths,SUM(cast(new_deaths as Int))/Sum(Nullif(new_cases,0))*100 as Deathpercentage  --total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DP
from PortfolioProject..CovidDeaths
--where location like 'India'
where continent is not null
--group by Date
order by 1,2


-- Join and use cte

with popvsvac (continent,location,date,population, new_vaccinations, rollvac)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as bigint)) over (Partition by dea.location) as rollvac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location= vac.location
where dea.continent is not null
--order by 2,3
)
select *, (rollvac/population)*100 as popvac
from popvsvac 
order by 1,2 desc






--Temp Table
Drop table  if exists #PercentPOPVAC
create Table #PercentPOPVAC
(
continent nvarchar(255),
Location Nvarchar(255),
Date datetime,
population numeric,
new_vaccination numeric,
rollvac numeric
)

Insert Into #PercentPOPVAC
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as bigint)) over (Partition by dea.location) as rollvac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location= vac.location
where dea.continent is not null
--order by 2,3
select *, (rollvac/population)*100 as popvac
from #PercentPOPVAC 
order by 1,2 desc

Drop table  if exists #PercentPOPVAC
create Table #PercentPOPVAC
(
continent nvarchar(255),
Location Nvarchar(255),
Date datetime,
population numeric,
new_vaccination numeric,
rollvac numeric
)

Insert Into #PercentPOPVAC
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as bigint)) over (Partition by dea.location) as rollvac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location= vac.location
--where dea.continent is not null
--order by 2,3
select *, (rollvac/population)*100 as popvac
from #PercentPOPVAC 
order by 1,2 desc




--view

create view PercentPOPVAC as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as bigint)) over (Partition by dea.location) as rollvac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location= vac.location
where dea.continent is not null
--order by 2,3



select * from PercentPOPVAC
