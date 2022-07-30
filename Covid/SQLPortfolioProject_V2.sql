Select *
From PortfolioProject..CovidDeaths$
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations$
--order by 3,4

--Select location, date, total_cases,new_cases,total_deaths,population
--From PortfolioProject..CovidDeaths$
--order by 1,2

--Looking at total cases vs total deaths:
-- we can see the likelihood of dying if you get covid in each country:
Select location, date, total_cases,population, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths$
Where location like '%switzerland%'
and continent is not null
order by 1,2

-- Looking at the total cases vs population:
--we can show what percentage of population has got covid:
Select location, date, total_cases, population, (total_cases/population)*100 as covid_positive_percentage
From PortfolioProject..CovidDeaths$
Where location like '%switzerland%'
and continent is not null
order by 1,2

--Lets see what country has the most cases comparing to its population:
Select location, population, MAX(total_cases) as highest_infection_count, MAX(total_cases/population)*100 as percent_of_population_having_covid
From PortfolioProject..CovidDeaths$
--Where location like '%switzerland%'
--Where continent is not null
Group by location, population
order by percent_of_population_having_covid desc


--Lets see how many people died. highest death count of each country:
Select location, population,MAX(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths$
Where continent is not null
--Where location like '%switzerland%'
Group by location, population
order by total_death_count desc


--Showing the continents with the highest death count:
Select continent, MAX(cast(total_Deaths as int)) as total_death_count_by_continent
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
order by total_death_count_by_continent desc



--gloabl numbers:
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths$
Where continent is not null
--Group by date
order by 1,2


--Now checking what I have in the other table (vaccination)
Select *
From PortfolioProject..CovidVaccinations$


--join both tables:
Select *
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
  On dea.location = vac.location
  and dea.date = vac.date

--looking at total population vs vaccinations:
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as total_people_vaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 1,2,3



--USING CTE(Common Table Expression):
with PopvsVac (continent, location, date, population, new_vaccinations, total_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as total_people_vaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (total_people_vaccinated/population)*100 as percentage_of_total_people_vaccinated
From PopvsVac



--USING TEMP TABLE:
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
total_people_vaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as total_people_vaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date

Select *, (total_people_vaccinated)*100 as percentage_of_total_people_vaccinated
From #PercentPopulationVaccinated



--Creating view to store data for later visualization:
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) 
	as total_people_vaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
Select *
From PercentPopulationVaccinated




