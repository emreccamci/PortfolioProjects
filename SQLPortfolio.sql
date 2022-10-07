--COVID 19 Turkey Data Exploration


--Shows the percentage of the population infected by Covid per day in Turkey

SELECT location, date, population, total_cases, (total_cases/population)*100 as InfectedPercantage
FROM PortfolioProject..CovidData
WHERE location = 'Turkey'
ORDER BY 1,2

--Shows the Mortality Percentage per day in Turkey

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as MortalityRate
FROM PortfolioProject..CovidData
WHERE location = 'Turkey'
ORDER BY 1,2

--Shows Percentage of Population that has recieved at least one Covid Vaccine in Turkey

SELECT location, date, population, new_vaccinations, SUM(CONVERT(int, new_vaccinations)) OVER (Partition by location ORDER BY location, date) as TotalVac,
(SUM(CONVERT(int, new_vaccinations)) OVER (Partition by location ORDER BY location, date)/population)*100 as VacRate
FROM PortfolioProject..CovidData
WHERE location = 'Turkey'
ORDER BY 1,2

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalVac numeric,
VacRate decimal,
)
INSERT into #PercentPopulationVaccinated
SELECT location, date, population, new_vaccinations, SUM(CONVERT(int, new_vaccinations)) OVER (Partition by location ORDER BY location, date) as TotalVac,
(SUM(CONVERT(int, new_vaccinations)) OVER (Partition by location ORDER BY location, date)/population)*100 as VacRate
FROM PortfolioProject..CovidData
WHERE location = 'Turkey'
ORDER BY 1,2

Select *
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
SELECT location, date, population, new_vaccinations, SUM(CONVERT(int, new_vaccinations)) OVER (Partition by location ORDER BY location, date) as TotalVac,
(SUM(CONVERT(int, new_vaccinations)) OVER (Partition by location ORDER BY location, date)/population)*100 as VacRate
FROM PortfolioProject..CovidData
WHERE location = 'Turkey'
