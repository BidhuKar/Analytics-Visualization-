#Create a sample database PROJECT
use PROJECT;
#---------------------------------------------------------
#Create table using import functions
#Load data from csv/excel files into the tabe
show tables;
#---------------------------------------------------------
#Merge tables using Union Operator
CREATE TABLE Tot_Hotels
select * from T2018
union
select * from T2019
union
select * from T2020;
#---------------------------------------------------------
select * from Tot_Hotels;
select count(*) from Tot_Hotels;
#---------------------------------------------------------
##Q.1: Is our hotel revenue growing yearly?
#An:In our dataset we don’t have revenue, but we do have adr (Average Daily Rate), stays_in_week_nights, and stays_in _weekend_nights. 
#So, we will create a new column 'revenue' by using the data of these three columns as follows.

select 
  (stays_in_week_nights + stays_in_weekend_nights) * adr
  as revenue from Tot_Hotels;
 
#Let’s bring another column arrival_date_year from the data and then calculate the sum of revenue while grouping the data by year.
 
select 
arrival_date_year,
sum((stays_in_week_nights + stays_in_weekend_nights) * adr)
as revenue from Tot_Hotels 
group by arrival_date_year;

#The result was giving a NULL row in result, applying IS NOT NULL 

select 
arrival_date_year,
sum((stays_in_week_nights + stays_in_weekend_nights) * adr)
as revenue from Tot_Hotels 
where  arrival_date_year is NOT NULL
group by arrival_date_year;

## Now, in the following table, we can see that the revenue increased from 2018 to 2019 but then decreased again in 2020.
#----------------------------------------------------------------------------------------------------------------------------
#We can also determine the revenue trend by hotel type by grouping the data by hotel and then seeing 
#which hotels have generated the most revenue.
select 
arrival_date_year,
hotel,
sum((stays_in_week_nights + stays_in_weekend_nights) * adr)
as revenue from Tot_Hotels 
where  arrival_date_year is NOT NULL
group by arrival_date_year,hotel;

#We can round the revenue values to 2 decimal places

select 
arrival_date_year,
hotel,
round(sum((stays_in_week_nights + stays_in_weekend_nights) * adr), 2)
as revenue from Tot_Hotels 
where  arrival_date_year is NOT NULL
group by arrival_date_year,hotel;

#----------------------------------------------------------------------------------------------------------------------------
#Q.2: Should we increase our parking lot size?
#To answer this question, we will focus on the car_parking_spaces and number of guests staying in the hotel. So, let’s do 
#it by applying the following SQL query.

select
arrival_date_year, hotel,
round(sum((stays_in_week_nights + stays_in_weekend_nights) * adr), 2) as revenue,
concat (round((sum(required_car_parking_spaces)/sum(stays_in_week_nights +
stays_in_weekend_nights)) * 100, 2), '%') as parking_percentage
from Tot_Hotels 
where  arrival_date_year is NOT NULL
group by arrival_date_year, hotel;


#In the next table we can observe that we have enough space for parking. 
#So, there is no need to increase our parking lot size.

#----------------------------------------------------------------------------------------------------------------------------

select * from PROJECT.t_market_segm;

select * from Tot_Hotels
left join PROJECT.t_market_segm
on Tot_Hotels.market_segment = t_market_segm.market_segment
left join PROJECT.t_meal_cost
on t_meal_cost.meal = Tot_Hotels.meal;


CREATE TABLE Hotel_Analysis
select * from Tot_Hotels
left join PROJECT.t_market_segm
on Tot_Hotels.market_segment = t_market_segm.market_segment
left join PROJECT.t_meal_cost
on t_meal_cost.meal = Tot_Hotels.meal;




  
 
