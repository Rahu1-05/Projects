create database pizza_sales;
Use pizza_sales;

create table orders(
order_id int not null,
order_date datetime not null,
order_time time not null,
primary key(order_id));

alter table orders modify column order_date Date; 

 
create table order_details(
order_deatils_id int not null,
order_id int not null,
pizza_id int not null,
quantity int not null,
primary key(order_deatils_id));

alter table order_details modify column pizza_id text;

select * from order_details;
select * from orders;
select * from pizzas;
select * from pizza_types;


----------------------------------------------------- || Analysis || ------------------------------------------------------------------------

-- Retrieve the total number of orders placed.
select count(order_id) from orders;

-- Calculate the total revenue generated from pizza sales.
select sum(o.quantity * p.price) as total_sales from order_details o 
join pizzas p on p.pizza_id = o.pizza_id;

-- Identify the highest-priced pizza.
select p.name, p1.price from pizza_types p
join pizzas p1 on p.pizza_type_id=p1.pizza_type_id
order by p1.price desc
limit 1;

-- Identify the most common pizza size ordered.
select p1.size, count(p1.size) as order_count from order_details o 
join pizzas p1 on o.pizza_id=p1.pizza_id
group by p1.size order by order_count desc;


-- List the top 5 most ordered pizza types along with their quantities.
select p.name, sum(quantity) as order_count from order_details o 
join pizzas p1 on o.pizza_id=p1.pizza_id join pizza_types p
on p1.pizza_type_id=p.pizza_type_id
group by p.name order by order_count desc
limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.
select p.category, sum(quantity) as order_count from order_details o 
join pizzas p1 on o.pizza_id=p1.pizza_id join pizza_types p
on p1.pizza_type_id=p.pizza_type_id
group by p.category order by order_count desc;


-- Determine the distribution of orders by hour of the day.
select hour(o.order_time) as Time, count(o.order_id) order_count from orders o
group by Time order by order_count desc;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(order_count),0) as avg_orders from 
(select o.order_date, sum(o1.quantity) as order_count from order_details o1
join orders o on o.order_id=o1.order_id
group by o.order_date) as order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue
select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue 
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by revenue desc 
limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue
select pizza_types.category, 
round(sum(order_details.quantity * pizzas.price) / (select round(sum(order_details.quantity * pizzas.price),2) 
	as total_sales 
from order_details 
		join pizzas 
	on pizzas.pizza_id = order_details.pizza_id),2)* 100 as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;












