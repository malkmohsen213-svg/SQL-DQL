
--Which products are performing above average? Find all products whose price is above the average price of all products .
-- Subquery
select Product.ProductName ,Product.Price 
from Product
where Price >(select AVG(Price)
              from Product) 
			  
--CTE

 with AvgPrice as(select AVG(Price) Avg_Price
                   from Product) 
select Product.ProductName ,Product.Price 
from Product
cross join avgPrice 
where Price > Avg_Price ;

--view
create view AvgPrice as 
select Product.ProductName ,Product.Price 
from Product
where Price > (select AVG(Price) Avg_Price
               from Product)
select *
from AvgPrice
           
--	Window Function
select ProductName , avg_price
from (
       select  Product.ProductName ,Product.Price ,AVG(Price)over(partition by categoryid) as avg_price
       from Product) AvgPrice
where Price> avg_price


--2: Find products that are above average, but only compared to their direct competitors—other products in the same category.
select *
from Product
-- 	Subquery
select p.ProductName , p.Price , p.CategoryID
from Product p 
join (select CategoryID , AVG(price) avg_price
                from Product 
				group by CategoryID ) AvgPrice on p.CategoryID = AvgPrice.CategoryID
where Price > avg_price

--CTE
with AvgPrice as(select CategoryID , AVG(price) avg_price
                from Product 
				group by CategoryID )

select p.ProductName , p.Price , p.CategoryID
from Product p 
cross join  AvgPrice
where Price > avg_price

--view
create view  Av_Price as 
select p.ProductName , p.Price , p.CategoryID
from Product p 
join (select CategoryID , AVG(price) avg_price
                from Product 
				group by CategoryID ) A_Price on p.CategoryID = A_Price.CategoryID
where price >avg_price

select*
from Av_Price

-- Window Function
select ProductName , Price , CategoryID,avg_price
from(
      select p.ProductName , p.Price , p.CategoryID, avg(price)over(partition by categoryid) as avg_price
      from Product p ) AvgPrice
	where Price > avg_price 

--3: Identify the champion products in each category. Find the product(s) with the highest price in each category.

--	Subquery
select  P.ProductName ,P.CategoryID ,Max_price
from Product P 
join (select  Product.CategoryID, max(Price) as Max_price
                from Product
				group by CategoryID ) MaxPrice on p.CategoryID =MaxPrice.CategoryID
where Price = Max_price
order by Max_price desc
				

-- CTE
with MaxPrice as (select Product.CategoryID , max(Price) as Max_price
                  from Product
				  group by CategoryID ) 

select  P.ProductName ,P.CategoryID,P.Price 
from Product P 
cross join MaxPrice
where Price = Max_price
order by Max_price desc

--View
create  view MaxPrice as 
select p.* ,Max_Price
from Product p
join (select Product.CategoryID , max(Price) as Max_Price
      from Product
	  group by CategoryID) Max_P on p.CategoryID = Max_P.CategoryID
where Price = Max_Price

select *
from MaxPrice

--Ranking Function
Select Productname , Price
from ( Select Productname ,Price,CategoryID, rank()over(partition by categoryid order by price desc) as max_price
       from Product ) maxPrice
where max_price = 1 
