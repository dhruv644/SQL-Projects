select top 1 * from catalogue_data
select top 1 * from rating_data
select top 1 * from consumption_data
select top 1 * from subscription_data

--Total Subscriptions

select count(subscription_key) as total_subscriptions
from subscription_data

--Total Revenue from Subscriptions

select sum(amount_paid) as revenue
from subscription_data

--Average Revenue per Subscription:

select plan_type , avg(amount_paid) as reveneue
from subscription_data
where plan_type is not null
group by plan_type

--Subscriptions percentage by plan type

select plan_type , count(subscription_key) as subscriptions,
(count(subscription_key)*1.0/(select count(subscription_key) from subscription_data))*100 
as [% of subscribers]
from subscription_data
where plan_type is not null
group by plan_type

--Subscriptions percentage by plan duration

select subscription_length , 
count(subscription_key)*1.0/(select count(subscription_key) from subscription_data)*100 as [% of subscribers]
from subscription_data
group by subscription_length
order by [% of subscribers] desc

--Calculate the total revenue generated per month.

select month(subscription_start_date) as months , round(sum(amount_paid),2) as revenue
from subscription_data
group by month(subscription_start_date)
order by revenue desc

--Monthly New Subscriptions:

select month(subscription_start_date) as months , count(user_id) as Subscriptions,
count(user_id) - lag(count(user_id),1) over (order by month(subscription_start_date))
from subscription_data
group by month(subscription_start_date)

--Monthly New Subscriptions:

select top 1 month(subscription_start_date) as months , count(user_id) as Subscriptions,
count(user_id) - lag(count(user_id),1) over (order by month(subscription_start_date)) as
[New Subs]
from subscription_data
group by month(subscription_start_date)
order by [New Subs] desc

