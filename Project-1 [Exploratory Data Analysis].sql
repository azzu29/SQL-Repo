-- EXPLORATORY DATA ANALYSIS [EDA]

Select *
from layoffs_stagging2;

select max(total_laid_off),max(percentage_laid_off)
from layoffs_stagging2;

Select *
from layoffs_stagging2
where percentage_laid_off = 1
order by funds_raised_millions DESC;

select company, sum(total_laid_off)
from layoffs_stagging2
group by company
order by 2 DESC;

-- ----------------------------------

-- Q] Find the total of canadian companies who laid off?
-- A] 
select country, company, sum(total_laid_off) AS total_laid_off
from layoffs_stagging2
where country = 'canada'
group by company
order by 3 DESC;

-- ---------------------------------

Select min(`date`), max(`date`)
from layoffs_stagging2;

select country, sum(total_laid_off)
from layoffs_stagging2
group by country
order by 2 DESC;

select *
from layoffs_stagging2;

select Year(`date`), sum(total_laid_off)
from layoffs_stagging2
group by Year(`date`)
order by 1 DESC;

select stage, sum(total_laid_off)
from layoffs_stagging2
group by stage
order by 2 DESC;

select company, avg(percentage_laid_off)
from layoffs_stagging2
group by company
order by 2 DESC;

-- Rolling Layoffs

select substring(`date`,1,7) AS `MONTH`, sum(total_laid_off)
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 ASC; 

-- We are getting the grouped total of month using CTE
-- WE get Month-By-Month Progression

with Rolling_Total AS
(
select substring(`date`,1,7) AS `MONTH`, sum(total_laid_off) AS total_off
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 ASC 
)
select `MONTH`, total_off,
sum(total_off) Over(order by `MONTH`) AS rolling_total
from Rolling_Total;

-- Companies which were laying off per year.

select company, sum(total_laid_off)
from layoffs_stagging2
group by company
order by 2 DESC;

select company, year(`date`), sum(total_laid_off)
from layoffs_stagging2
group by company, year(`date`)
order by 3 DESC;

-- Based on the layoffs rank number 1

WITH Company_Year (company, years, total_laid_off) AS
(
select company, year(`date`), sum(total_laid_off)
from layoffs_stagging2
group by company, year(`date`) -- Created First CTE 
), Company_Year_Rank AS  -- Created RANK 
(select *, 
dense_rank() Over(PARTITION BY years order by total_laid_off DESC) AS Ranking
from Company_Year
where years is not null
) -- Created Second CTE with comma
select *
from Company_Year_Rank
where Ranking >= 5;



-- ------------------------------------------------------------------------------------------