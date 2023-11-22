select * from portfolioproject.covid_pandemic order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject.covid_pandemic
order by 1,2;

-- looking at total cases vs total deaths
select location, date, total_cases, new_cases, total_deaths, (total_deaths / total_cases) * 100 as DeathPercentage
from portfolioproject.covid_pandemic
where location not like '%Afghanistan%'
order by 1,2;

-- looking at the total cases vs population
select location, date, total_cases, population, (total_cases / population) * 100 as DeathPercentage
from portfolioproject.covid_pandemic
where location like '%Africa%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population

select location, date, max(total_cases) as highest_infection_rate, population, max((total_cases / population)) * 100 as PercentagePopulationInfected
from portfolioproject.covid_pandemic
-- where location like '%Africa%'
group by location, population, date
order by PercentagePopulationInfected desc;

-- showing countires with the highest death count per population

select continent, location, avg(total_deaths) as TotalDeathCount -- , population, max((total_cases / population)) * 100 as PercentagePopulationInfected
from portfolioproject.covid_pandemic
-- where location like '%Africa%'
where continent is not null
group by location, continent
order by TotalDeathCount desc;

-- showing the continent with the highest death count per population
select date, sum(new_cases), sum(new_deaths) -- total_cases,total_deaths , population, max((total_cases / population)) * 100 as PercentagePopulationInfected
from portfolioproject.covid_pandemic
-- where location like '%Africa%'
where continent is not null
group by date
order by 1,2;
select pan.continent, pan.location, pan.date, pan.population , vac.new_vaccinations,
sum(new_vaccinations) over (partition by pan.location order by pan.location, pan.date)
from portfolioproject.covid_pandemic pan
join portfolioproject.covid_vaccination vac
on pan.location = vac.location
and pan.date = vac.date
where pan.continent is not null
-- group by pan.continent, pan.location, pan.population  , vac.new_vaccinations
order by 2, 3;

select * from portfolioproject.covid_pandemic order by 3,4;
select * from portfolioproject.covid_vaccination order by 3,4;

-- using CTE--
with popvsvac (continent, location, date, population, new_vaccination, rollingPeopleVaccine)
as
(
select pan.continent, pan.location, pan.date, pan.population , vac.new_vaccinations,
sum(new_vaccinations) over (partition by pan.location order by pan.location, pan.date) as rollingPeopleVaccine
-- ,(rollingPeopleVaccine / population) * 100
from portfolioproject.covid_pandemic pan
join portfolioproject.covid_vaccination vac
on pan.location = vac.location
and pan.date = vac.date
where pan.continent is not null
-- group by pan.continent, pan.location, pan.population  , vac.new_vaccinations
-- order by 2, 3;
) select *, (rollingPeopleVaccine / population) * 100 from popvsvac;


-- temp table
-- Drop Table if exists #percentagepopulationVaccinated
Create Table #percentagepopulationVaccinated (
continent nvarchar(255),location nvarchar(255),date datetime,population numeric,new_vaccination numeric,rollingPeopleVaccine numeric
)
INSERT into #percentagepopulationVaccinated 
select pan.continent, pan.location, pan.date, pan.population , vac.new_vaccinations,
sum(new_vaccinations) over (partition by pan.location order by pan.location, pan.date) as rollingPeopleVaccine
-- ,(rollingPeopleVaccine / population) * 100
from portfolioproject.covid_pandemic pan
join portfolioproject.covid_vaccination vac
on pan.location = vac.location
and pan.date = vac.date
where pan.continent is not null
-- group by pan.continent, pan.location, pan.population  , vac.new_vaccinations
 -- order by 2, 3 
 select *, (rollingPeopleVaccine / population) * 100 from #percentagepopulationVaccinated;
 
 
 -- creating a view to store data for later visualizations
 
 create view percentagepopulationvaccinated as
 select pan.continent, pan.location, pan.date, pan.population , vac.new_vaccinations,
sum(new_vaccinations) over (partition by pan.location order by pan.location, pan.date) as rollingPeopleVaccine
-- ,(rollingPeopleVaccine / population) * 100
from portfolioproject.covid_pandemic pan
join portfolioproject.covid_vaccination vac
on pan.location = vac.location
and pan.date = vac.date
where pan.continent is not null ;
-- group by pan.continent, pan.location, pan.population  , vac.new_vaccinations
 -- order by 2, 3 
