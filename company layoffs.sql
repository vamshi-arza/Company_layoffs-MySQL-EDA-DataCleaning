
-- Removing duplicates
select *
from layoffs;

create table layoffs_staging
like layoffs; /*copying the entire table columns of layoffs into layoffs_staging*/

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs; /*copying all the values of layoffs into the table layoffs_staging*/


select *,
row_number() over(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
from layoffs_staging;

with duplicate_cte AS
(
select *,
row_number() over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging 
)
select * 
from duplicate_cte
where row_num > 1;

select *
from layoffs_staging
where company = "Casper";



CREATE TABLE `layoffs_staging4` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select *
from layoffs_staging4
where row_num > 1;

insert into layoffs_staging4
select *,
row_number() over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging; 

SET SQL_SAFE_UPDATES = 0;

delete 
from layoffs_staging4
where row_num > 1;

SET SQL_SAFE_UPDATES = 1;

select *
from layoffs_staging4;

-- Standardizing data

select company, trim(company)
from layoffs_staging4;

update layoffs_staging4
set company =  trim(company);

select *
from layoffs_staging4
where industry like "Crypto%";

update layoffs_staging4
set industry = "Crypto"
where industry like "Crypto%";

select distinct country
from layoffs_staging4
order by 1;

update layoffs_staging4
set country = trim(trailing '.' from country)
where country like "United States%" ;

select *
from layoffs_staging4;


update layoffs_staging4
set `date` = str_to_date(`date`, '%m/%d/%Y');


alter table layoffs_staging4
modify column `date` DATE;

select *
from layoffs_staging4;

-- working with null values

select *
from layoffs_staging4
where total_laid_off IS NULL
and percentage_laid_off IS NULL;


update layoffs_staging4
set industry = NULL
WHERE industry = '';


select *
from layoffs_staging4
where industry IS NULL
OR industry = '';


select *
from layoffs_staging4
where company like "Bally%";


select *
from layoffs_staging4 t1
join layoffs_staging4 t2
     ON t1.company = t2.company
     AND t1.location = t2.location
where (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

update layoffs_staging4 t1
join layoffs_staging4 t2
     ON t1.company = t2.company
SET t1.industry = t2.industry
where (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

select *
from layoffs_staging4
where total_laid_off IS NULL
and percentage_laid_off IS NULL;


delete
from layoffs_staging4
where total_laid_off IS NULL
and percentage_laid_off IS NULL;

-- Remove any columns

ALTER table layoffs_staging4
DROP COLUMN row_num;

-- Exploratory data analysis of the cleaned data

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging4; 
-- which company has 1 which is basically 100 percent of the company laid off and we order by funds_raised_millions we can see how big some of these companies were
select * 
from layoffs_staging4
where percentage_laid_off = 1 and country = "India"
order by funds_raised_millions desc;



select min(`date`), max(`date`)
from layoffs_staging4; 
-- total layoffs by year
select year(`date`), sum(total_laid_off)
from layoffs_staging4
group by year(`date`)
order by 2 desc;
-- total layoffs by industry
select industry, sum(total_laid_off)
from layoffs_staging4
group by industry
order by 2 desc;
-- total layoffs by stage
select stage, sum(total_laid_off)
from layoffs_staging4
group by stage
order by 2 desc;
-- total layoffs by country
select country, sum(total_laid_off)
from layoffs_staging4
group by country
order by 2 desc;

-- Rolling Total of Layoffs Per Month
select substring(`date`, 1, 7) as `Month`, sum(total_laid_off)
from layoffs_staging4
where substring(`date`, 1, 7) IS NOT NULL
group by `Month`
order by 1 asc;


WITH Rolling_total AS
(
select substring(`date`, 1, 7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging4
where substring(`date`, 1, 7) IS NOT NULL
group by `Month`
order by 1 asc
)
select `Month`, total_off 
,SUM(total_off) over(order by `Month`) as rolling_total
from Rolling_total;

-- Companies with most layoffs pre year
select company, sum(total_laid_off)
from layoffs_staging4
group by company
order by 2 desc;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging4
group by company, year(`date`)
order by company asc;

with company_year (company, years, total_laid_off) AS 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging4
group by company, year(`date`)
)
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
order by ranking asc;



with company_year (company, years, total_laid_off) AS 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging4
group by company, year(`date`)
), company_year_rank as(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank;



