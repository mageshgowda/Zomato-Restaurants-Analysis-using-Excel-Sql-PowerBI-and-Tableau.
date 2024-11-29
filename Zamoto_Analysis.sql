create database zamoto_analysis;

select * from main;
select * from country;
select * from currency;

set sql_safe_updates =0;

UPDATE main SET Datekey_Opening = REPLACE(Datekey_Opening, '_', '/') WHERE Datekey_Opening LIKE '%_%';
alter table main modify column Datekey_Opening date;


#2.
select year(Datekey_Opening) years,
month(Datekey_Opening)  months,
day(datekey_opening) day ,
monthname(Datekey_Opening) monthname,Quarter(Datekey_Opening)as quarter,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday,
dayname(datekey_opening)dayname, 

case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,

case when monthname(datekey_opening)='January' then 'FM10' 
when monthname(datekey_opening)='February' then 'FM11'
when monthname(datekey_opening)='March' then 'FM12'
when monthname(datekey_opening)='April'then'FM1'
when monthname(datekey_opening)='May' then 'FM2'
when monthname(datekey_opening)='June' then 'FM3'
when monthname(datekey_opening)='July' then 'FM4'
when monthname(datekey_opening)='August' then 'FM5'
when monthname(datekey_opening)='September' then 'FM6'
when monthname(datekey_opening)='October' then 'FM7'
when monthname(datekey_opening)='November' then 'FM8'
when monthname(datekey_opening)='December'then 'FM9'
end Financial_months,
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters

from Main;


#3.Find the Numbers of Resturants based on City and Country.
select country.countryname,main.city,count(*)no_of_restaurants
from main inner join country 
on main.countrycode=country.countryid 
group by country.countryname,main.city;


#4.Numbers of Resturants opening based on Year , Quarter , Month.
select year(datekey_opening)year,quarter(datekey_opening)quarter,
monthname(datekey_opening)monthname,count(restaurantid)as no_of_restaurants 
from main group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) 
order by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening);


#5. Count of Resturants based on Average Ratings.
SELECT main.Rating, COUNT(main.RestaurantID) AS Number_of_Restaurants
FROM main GROUP BY main.Rating
ORDER BY main.Rating DESC;


#6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select case
 when price_range=1 then "0-500" 
 when price_range=2 then "500-3000" 
 when Price_range=3 then "3000-10000"
 when Price_range=4 then ">10000" 
 end price_range,count(restaurantid)
from main 
group by price_range
order by Price_range;


#7.Percentage of Resturants based on "Has_Table_booking"
select has_online_delivery,concat(round(count(Has_Online_delivery)/100,1),"%") percentage 
from main 
group by has_online_delivery;


#8.Percentage of Resturants based on "Has_Online_delivery"
select has_table_booking,concat(round(count(has_table_booking)/100,1),"%") percentage 
from main
group by has_table_booking;


# highest rating restaurants in each country 
select  countryname,max(rating)highest_rating 
from main inner join country on main.countrycode=country.countryid
group by country.countryname;


# top 5 restaurants who has more number of votes
select  countryname,votes,Average_Cost_for_two 
from main inner join country on main.countrycode=country.countryid
group by country.countryname,votes,Average_Cost_for_two
order by votes desc limit 5;


#Top 5 restaurant with highest rating and votes from each country
select  countryname,max(rating)highest_rating,max(votes)
 from main inner join country on main.countrycode=country.countryid
group by countryname order by max(votes) desc limit 5;


#TOP 10 Restaurants per Cuisine in Each Country
SELECT country.CountryName, main.Cuisines, COUNT(main.RestaurantID) AS Total_Restaurants
FROM main INNER JOIN country ON main.CountryCode = country.CountryID
GROUP BY country.CountryName, main.Cuisines
ORDER BY Total_Restaurants DESC limit 10;



