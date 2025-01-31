create database retail_store

select * from Customer
select * from Transactions
select * from prod_cat_info

-----data prep

--Q1

select count (*) from Customer as customer
union
select count (*) from prod_cat_info as products
union
select count (*) from Transactions as total_rows



--Q2

select count(distinct transaction_id) as returns
from Transactions
where total_amt < 0

--Q3

select convert(date , tran_date ,105) as dates
from Transactions





--Q4

select DATEDIFF( day , min(CONVERT(date , tran_date ,105)) , 
max(CONVERT(date , tran_date ,105)))as total_dates ,
DATEDIFF( month , min(CONVERT(date , tran_date ,105)) , 
max(CONVERT(date , tran_date ,105)))as total_months ,
DATEDIFF( year , min(CONVERT(date , tran_date ,105)) , 
max(CONVERT(date , tran_date ,105)))as total_year
from Transactions


--Q5

select prod_subcat , prod_cat
from prod_cat_info
where prod_subcat = 'DIY'

----------------------------------------------------------data analysis------------------------------------------------------------


--Q1

select top 1 Store_type , count(transaction_id) as channel
from Transactions
group by Store_type
order by channel desc

--Q2

select gender , count(customer_id) as counts
from Customer
where gender is not null
group by Gender

--Q3

select top 1 city_code , COUNT(customer_id) as customers
from Customer
group by city_code
order by customers desc

--Q4

select prod_cat ,count(prod_subcat) as booksCat
from prod_cat_info
where prod_cat = 'books'
group by prod_cat

--Q5

select prod_cat_code , max(Qty) as quantity
from Transactions
group by prod_cat_code

--Q6

	select sum( cast (total_amt as float)) as revenue from Transactions as t
	inner join prod_cat_info as p
	on t.prod_subcat_code = p.prod_sub_cat_code and t.prod_cat_code = p.prod_cat_code
	where p.prod_cat in ('electronics' , 'books')
	and total_amt > 0
	
	
--Q7
select count(*) as total_count from(
	select cust_id , COUNT(distinct transaction_id) as counts 
	from Transactions 
	where qty > 0
	group by cust_id
	having COUNT(distinct transaction_id) > 10
	) as x

--Q8

		select 
		sum(cast(total_amt as float)) as revenue from Transactions as t
		inner join prod_cat_info as p 
		on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code = p.prod_sub_cat_code
		where p.prod_cat in ('electronics' , 'clothing')
		    and 
			  Store_type = 'Flagship store'

--Q9

select p.prod_subcat , sum (cast(total_amt as float)) as revnue from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code = p.prod_sub_cat_code
inner join Customer as c
on c.customer_Id = t.cust_id
where Gender = 'M'
  and 
     prod_cat = 'electronics'
group by p.prod_subcat

--Q10
 
 select [%ofsales].prod_subcat , percentofsales , percentofreturn from (

 select top 5 prod_subcat , sum(cast(total_amt as float))/(select sum(cast(total_amt as float)) from transactions
 where total_amt > 0)*100 as [percentofsales] 
 from Transactions as t
 join prod_cat_info as p
 on p.prod_cat_code = t.prod_cat_code and p.prod_sub_cat_code = t.prod_subcat_code
 where total_amt > 0
 group by prod_subcat
 order by [percentofsales] desc) as [%ofsales]
 inner join
  (select prod_subcat , sum(cast(total_amt as float))/(select sum(cast(total_amt as float)) from transactions where total_amt < 0)*100 
  as [percentofreturn] 
 from Transactions as t
 join prod_cat_info as p
 on p.prod_cat_code = t.prod_cat_code and p.prod_sub_cat_code = t.prod_subcat_code
 where total_amt < 0
 group by prod_subcat) as [%ofreturn]
 on [%ofsales].prod_subcat = [%ofreturn].prod_subcat


 --Q11

 select  sum(revenue) as total_revenue from(
	select customer_id , DATEDIFF(year , min(DOB) , max(convert(date,tran_date,105))) as age , 
	sum(cast(total_amt as float)) as revenue from Customer as c
	inner join Transactions as t
	on c.customer_Id = t.cust_id
	where qty > 0 and tran_date > (select
dateadd(day , -30 , max(convert(date , tran_date , 105)) ) as prev_date
from Transactions)

	group by customer_Id 
	having  DATEDIFF(year , min(DOB) , getdate()) between 25 and 35
) as x



--Q12

select top 1 prod_cat,count(Qty) as returns from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code = p.prod_sub_cat_code
where Qty < 0 and tran_date >= (select dateadd(month , -3 , max(convert(date , tran_date , 105))) from Transactions)
group by prod_cat
order by returns desc
`	1	`
--Q13

select store_type ,sum(qty) as quantity , sum(cast(total_amt as float)) as sales 
from Transactions as t
inner join prod_cat_info as p
on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code = p.prod_sub_cat_code
where qty > 0
group by Store_type
order by  sales desc

--Q14

select * from(
			select prod_cat , avg(cast(total_amt as float)) as avg_revenue
			from Transactions as t
			inner join prod_cat_info as p
			on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code = p.prod_sub_cat_code
			where Qty > 0
			group by prod_cat
			) as x
where avg_revenue > (select avg(cast(total_amt as float)) from Transactions where Qty > 0) 

--Q15

select prod_subcat_code , avg(cast(total_amt as float)) as avg_revenue , sum(cast(total_amt as float)) as revenue
from Transactions 
where qty > 0 and prod_cat_code in
( select top 5 prod_cat_code from Transactions where qty > 0 group by prod_cat_code 
order by sum(qty) desc)
group by prod_subcat_code;




