-- DATA CLEANING PROJECT

select * 
from layoffs;

-- PROCESS OF CLEANING THE DATA

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or Blank values
-- 4. Remove any Columns

create table layoffs_stagging
like layoffs;

select * 
from layoffs_stagging;

insert layoffs_stagging
select * 
from layoffs; 

select * 
from layoffs_stagging;

select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num 
from layoffs_stagging;

-- Using cte
with duplicate_cte as
(
select *,
row_number() over(
partition by company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num 
from layoffs_stagging
) 
select * 
from duplicate_cte
where row_num > 1;

select * 
from layoffs_stagging
where company = 'Casper';

-- So do delete an duplicated data from the data we have to create another table then delete.


CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_stagging2
where row_num > 1;

insert into layoffs_stagging2
select *,
row_number() over(
partition by company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
from layoffs_stagging;


Delete
from layoffs_stagging2
where row_num > 1;

select * 
from layoffs_stagging2;

-- 2. Standardizing data [Find the issues in the data and fixing it]

select company, trim(company)
from layoffs_stagging2;

update layoffs_stagging2
set company = trim(company);

select distinct (industry) -- using order by.
from layoffs_stagging2
order by 1;

select * 
from layoffs_stagging2
where industry like 'Crypto%'; -- fixing and updating all the crypto words

update layoffs_stagging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct(industry) 
from layoffs_stagging2;

select distinct country, trim(trailing '.' from country)
from layoffs_stagging2
order by 1	;

update layoffs_stagging2
set country = trim(trailing '.' from country)
where country like 'United States%';

-- Now converting and formating the date column text - date

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_stagging2;

update layoffs_stagging2
set date = str_to_date(`date`,'%m/%d/%Y');

Alter table layoffs_stagging2 -- To change the data type of the date in the duplicate table
modify column `date` date;

select * 
from layoffs_stagging2
where total_laid_off is Null
and percentage_laid_off is Null;

update layoffs_stagging2
set industry = Null
where industry = '';

select *
from layoffs_stagging2
where industry is null
or industry = '';

select * 
from layoffs_stagging2
where company = 'Airbnb'; 

select *
from layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
where (t1.industry is Null or t1.industry = '')
and t2.industry is Not Null;

update layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is Null 
and t2.industry is Not Null;

select * 
from layoffs_stagging2
where company like 'Bally%'; -- Finding Individual null or blank values from inside the company.

select * 
from layoffs_stagging2;

select * 
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

Delete
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

select * 
from layoffs_stagging2;

Alter table layoffs_stagging2
drop column row_num;

-- -------------------- <--- PART 2 --> --------------------

