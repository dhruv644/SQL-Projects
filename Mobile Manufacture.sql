select top 1 * from DIM_CUSTOMER
select top 1 * from DIM_DATE
select top 1 * from DIM_LOCATION
select top 1 * from DIM_MANUFACTURER
select top 1 * from DIM_MODEL
select top 1 * from FACT_TRANSACTIONS

--Q1

--Begin

select State , count(idcustomer) as customers from DIM_LOCATION as dl
inner join FACT_TRANSACTIONS as f
on dl.IDLocation = f.IDLocation
where year(date) >= '2005'
group by State

--End

--Q2

--Begin

select * from DIM_MANUFACTURER as dm
join DIM_MODEL as md
on dm.IDManufacturer = md.IDManufacturer
join FACT_TRANSACTIONS as f 
on md.IDModel = f.IDModel

--Q6

select Customer_Name , AVG(totalPrice) as avg_amount from DIM_CUSTOMER as c
join FACT_TRANSACTIONS as f
on c.IDCustomer = f.IDCustomer
where year(date) = '2009'
group by Customer_Name
having AVG(totalPrice) > 500

--Q7

select model_name ,  COUNT(model_name) as cnt from (
select top 5 Model_Name , sum(quantity) as quantity from DIM_MODEL as dm
join FACT_TRANSACTIONS as f
on dm.IDModel = f.IDModel
where year(date) = '2008'
group by Model_Name
order by quantity desc
union
select top 5 Model_Name , sum(quantity) as quantity from DIM_MODEL as dm
join FACT_TRANSACTIONS as f
on dm.IDModel = f.IDModel
where year(Date) = '2009'
group by Model_Name
order by quantity desc
union
select top 5 Model_Name , sum(quantity) as quantity from DIM_MODEL as dm
join FACT_TRANSACTIONS as f
on dm.IDModel = f.IDModel
where year(Date) = '2010'
group by Model_Name
order by quantity desc) as x
group by Model_Name
having COUNT(model_name) >2


--Q8

select Manufacturer_Name from(
select Manufacturer_Name , sum(totalprice) as sales , DENSE_RANK () over (order by sum(totalprice) desc) as ranks
from DIM_MANUFACTURER as dm
join DIM_MODEL as md
on dm.IDManufacturer = md.IDManufacturer
join FACT_TRANSACTIONS as f 
on md.IDModel = f.IDModel
where year(date) = '2009' 
group by Manufacturer_Name
union
select Manufacturer_Name , sum(totalprice) as sales , DENSE_RANK () over (order by sum(totalprice) desc) as ranks
from DIM_MANUFACTURER as dm
join DIM_MODEL as md
on dm.IDManufacturer = md.IDManufacturer
join FACT_TRANSACTIONS as f 
on md.IDModel = f.IDModel
where year(date) = '2010' 
group by Manufacturer_Name
) as x where ranks = 2

--Q9

select Manufacturer_Name --, COUNT(model_name) as models
from DIM_MANUFACTURER as dm
join DIM_MODEL as md
on dm.IDManufacturer = md.IDManufacturer
join FACT_TRANSACTIONS as f 
on md.IDModel = f.IDModel
where YEAR(date) = '2010'
group by Manufacturer_Name
except
select Manufacturer_Name --, COUNT(model_name) as models
from DIM_MANUFACTURER as dm
join DIM_MODEL as md
on dm.IDManufacturer = md.IDManufacturer
join FACT_TRANSACTIONS as f 
on md.IDModel = f.IDModel
where YEAR(date) = '2009'
group by Manufacturer_Name

--Q10

select customer_name , YEAR(date) as years , avg(totalprice) as spend , avg(quantity) as avg_qnty , *
from DIM_CUSTOMER as dc
inner join FACT_TRANSACTIONS as fc
on dc.IDCustomer = fc.IDCustomer
group by customer_name , YEAR(date)

select  *
from DIM_CUSTOMER as dc
inner join FACT_TRANSACTIONS as fc
on dc.IDCustomer = fc.IDCustomer