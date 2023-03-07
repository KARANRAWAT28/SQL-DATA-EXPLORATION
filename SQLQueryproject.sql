select*
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
where continent is not null
order by 3, 4

--select*
--from [Portfolio Project 1 SQL - Covid].dbo.vaccine$
--order by 3, 4


select location,date,total_cases, new_cases, total_deaths,population
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
where continent is not null
order by 1,2


--Looking at the Total cases VS Total Deaths
--Shows likelihood of dying if you contract covid in your country
select location,date,total_cases, total_deaths , (total_deaths/total_cases)*100 as Deathpercentage
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
where location like 'india'
and continent is not null
order by 1,2

--Looking at Total Cases VS Population
--Shows what percentage of population got covid

select location,date,population  ,total_cases, (total_cases/population)*100 as PercentPopulationInfected
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
 --where location like 'india'
order by 1,2

--Looking at Countries with Highest Infection Rate Compared to Population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
--where location like 'india'
group by location, population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
--where location like 'india'
where continent is not null
group by location
order by TotalDeathCount desc


-- Breaking Data into Number of Case by Continent
-- Showing Continent with the highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
--where location like 'india'
where continent is not null
group by continent
order by TotalDeathCount desc


--Breaking Global Number

select sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$
--where location like 'india'
where continent is not null
--group by date
order by 1,2


-- Looking at Total Population VS Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$ dea
join [Portfolio Project 1 SQL - Covid].dbo.vaccine$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
   order by 2,3


-- USE CTE

with PopvsVac(continent, location, date, population,new_vaccinations, rollingpeoplevaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$ dea
join [Portfolio Project 1 SQL - Covid].dbo.vaccine$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
 --order by 2,3
 )
 select* , (rollingpeoplevaccinated/population)*100
 from PopvsVac


-- TEMP TABLE 

Create table  #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$ dea
join [Portfolio Project 1 SQL - Covid].dbo.vaccine$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
 --order by 2,3

  select* , (rollingpeoplevaccinated/population)*100
 from #PercentPopulationVaccinated


--Creating view to store data for latere visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from [Portfolio Project 1 SQL - Covid].dbo.Sheet1$ dea
join [Portfolio Project 1 SQL - Covid].dbo.vaccine$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3





