select top 1 * from catalogue_data
select top 1 * from rating_data
select top 1 * from consumption_data
select top 1 * from subscription_data

--Different rating categories given by the users

select  distinct rating
from rating_data

--Total Content whose rating is not given by the users

select count(feedback_id) as content_not_rated
from rating_data
where rating = 'Not_rated'


--Contents with the highest rating

select title , count(title) as ratings
from rating_data as rd
inner join consumption_data as cd
on rd.userid = cd.userid and rd.usersessionid = cd.usersessionid
inner join catalogue_data as c
on cd.content_id = c.content_id
where rd.rating = 'Awesome'
group by title
order by ratings desc

--Which content will be removed in the coming time?

select title
from catalogue_data
where status = 'Relegated'

--Content from horror categoy

select title
from catalogue_data
where listed_in like '%horror%'

--Top rated content from India

select title , sum(user_duration) as user_watchtime
from rating_data as rd
inner join consumption_data as cd
on rd.userid = cd.userid and rd.usersessionid = cd.usersessionid
inner join catalogue_data as c
on cd.content_id = c.content_id
where country = 'india'
and
rd.rating = 'Awesome'
group by title
order by user_watchtime desc




--



