select*
from Portfolio1..CovidDeaths
where continent is not null
order by 3,4

select*
from Portfolio1..CovidVaccinations
order by 3,4

--select*
--from Portfolio1..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from Portfolio1..CovidDeaths
where continent is not null
order by 1,2


--looking at total cases vs total deaths
--Shows likelihood of dying if u contact corona virus

select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from Portfolio1..CovidDeaths
where continent is not null
--where location = 'india'
order by 1,2

-- Looking at total cases vs population
-- Shows what percentage of population got covid

select location, date, total_cases, new_cases, total_deaths, population, (total_cases/population)*100 as [Infected population]
from Portfolio1..CovidDeaths
where continent is not null
--where location = 'india'
order by 1,2

--Looking at countries with highest infection rate compared to population
--
select Location, Population, max(Total_Cases) as [Highest Infection Count], MAX((total_cases/population))*100 As [Infected Population]
from CovidDeaths
where continent is not null
--where location='india'
group by location,population
order by [Infected Population] desc

--Showing Countries with highest death count per Population

select Location, Population, max(cast(Total_deaths as int)) as [Highest Death Count], MAX((total_deaths/population))*100 As [Deaths Per Population]
from CovidDeaths
where continent is not null
--where location='india'
group by location,population
order by [Deaths Per Population] desc

select Location, max(cast(Total_deaths as int)) as [Highest Death Count]
from CovidDeaths
where continent is not null
--where location='india'
group by location
order by [Highest Death Count] desc

---BY CONTINENTS
-- Global death rate

select continent, max(cast(Total_deaths as int)) as [Highest Death Count]
from CovidDeaths
where continent is not null
--where location='india'
group by continent
order by [Highest Death Count] desc

-- Joining tables death to know the people vaccinated

select dea.location,dea.continent,dea.date,dea.population, vac.new_vaccinations
from CovidDeaths as dea
join CovidVaccinations as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
and vac.new_vaccinations is not null
order by 1,2,3

--Rolling vaccination count by Location

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from CovidDeaths as dea
join CovidVaccinations as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Creating temp table to know the percentage of rolling people vaccinated

drop table if exists #per
create table #per(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination int,
rollingpeoplevaccinated int,
)
insert into #per
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from CovidDeaths as dea
join CovidVaccinations as vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
order by 2,3

select* , (rollingpeoplevaccinated/population)*100 as Rollingpeoplevaccinatedpercentage
from #per

--Creating view for visualization in Power BI

create view continent_wise_deaths as
select continent, max(cast(Total_deaths as int)) as [Highest Death Count]
from CovidDeaths
where continent is not null
--where location='india'
group by continent
--order by [Highest Death Count] desc

select* from continent_wise_deaths
