create database walmart;
create table sales(
invoice_id varchar(30) primary key,
Tablesbranch_id varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment varchar(15) not null,
cogs decimal (10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)
 );
 
 
 
 -- -------------------------------------------------------------------------------------------------
 -- ------------------------- Feature Engineering ---------------------------------------------------
 
 -- time_of_day
 
 
 select time from sales;
 select time,
	(case 
    when time between "00:00:00" and "12:00:00" then "Morning"
    when time between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
    end) as time_of_date
from sales;

alter table sales add column  time_of_day varchar(20);

update sales 
set time_of_day = (
	case 
		when time between "00:00:00" and "12:00:00" then "Morning"
		when time between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening"
    end
);
    
    
-- day_name
 
 
select date,dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);


-- month_name 


select date,monthname(date) as day_name
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

-- --------------------------------------------------------------------------------------------------
-- ----------------------------------- Generic Analysis ---------------------------------------------


-- How many unique cities does the data have?
select distinct(city) from sales;

select distinct(city), branch from sales;

-- --------------------------------------------------------------------------------------------------
-- ---------------------------------- Product Analysis ----------------------------------------------

-- How many unqiue product line does the data have?
select distinct(product_line) from sales;

-- What is most common payment method?
select payment,count(payment) as cnt from sales
group by payment
order by cnt desc;

-- What is the most selling product line?
select product_line,count(product_line) as cnt from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select month_name as month,sum(total) as Total from sales
group by month
order by Total desc;

-- What month had the largest COGS?
select month_name as month, sum(cogs) as Total 
from sales
group by month
order by Total desc;


-- What product line had the largest revenue?
select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?
select branch, city, sum(total) as revenue
from sales
group by city,branch
order by revenue desc;

-- What product line had the largest VAT?
select product_line, avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- Which branch sold more products than average product sold?
select branch, sum(quantity) as quantity
from sales
group by branch
having quantity > (select avg(quantity) from sales)
order by quantity desc;


-- What is the most common product line by gender?
select gender, product_line, count(gender) as count
from sales 
group by gender, product_line
order by count desc;


-- What is the average rating of each product line?
select product_line, round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

-- ---------------------------------------------------------------------------------------------------
-- ---------------------------------- Sales Analysis -------------------------------------------------

-- Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;


-- Which of the customer types brings the most revenue?
select customer_type, sum(total) as revenue 
from sales 
group by customer_type
order by revenue desc;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, avg(VAT) as VAT
from sales
group by city 
order by VAT desc;


-- Which customer type pays the most in VAT?
select customer_type, avg(VAT) as VAT 
from sales 
group by customer_type
order by VAT desc;

-- ----------------------------------------------------------------------------------------------
-- -------------------------------- Customer Analysis -------------------------------------------

-- How many unique customer types does the data have?
select distinct(customer_type) from sales;


-- How many unique payment methods does the data have?
select distinct(payment) from sales;


-- What is the most common customer type?
select customer_type, count(customer_type) as count
from sales
group  by customer_type
order by count desc;


-- Which customer type buys the most?
select customer_type, count(*) as cust_count
from sales
group  by customer_type;



-- What is the gender of most of the customers?
select gender,count(*) as gender_cnt 
from sales
group by gender
order by gender_cnt desc;



-- What is the gender distribution per branch?
select gender,count(*) as gender_cnt 
from sales
where branch="B"
group by gender
order by gender_cnt desc;



-- Which time of the day do customers give most ratings?
select time_of_day,round(avg(rating),2) as avg_rating
from sales
group by time_of_day
order by avg_rating;



-- Which time of the day do customers give most ratings per branch?
select time_of_day,round(avg(rating),2) as avg_rating
from sales
where branch ="B"
group by time_of_day
order by avg_rating desc;



-- Which day fo the week has the best avg ratings?
select day_name,round(avg(rating),2) as avg_rating
from sales
group by day_name
order by avg_rating desc;



-- Which day of the week has the best average ratings per branch?
select day_name,round(avg(rating),2) as avg_rating
from sales
where branch ="A"
group by day_name
order by avg_rating desc;

-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
