--Find list of airport codes in Europe/Moscow timezone

select airport_code
from bookings.airports_data
where timezone = 'Europe/Moscow'

--Write a query to get the count of seats in various fare condition for every aircraft code?

select aircraft_code,
fare_conditions,
count(seat_no) as seat_count
from bookings.seats
group by 1,2
order by 1

--How many aircrafts codes have at least one Business class seats?

select aircraft_code
from (select aircraft_code,
fare_conditions,
count(seat_no) as seat_count
from bookings.seats
group by 1,2
order by 1) as table1
where fare_conditions = 'Business' and seat_count >= 1

--Find out the name of the airport having maximum number of departure flight

select ad.airport_name,
dept.dept_flight_count
from (select departure_airport,
count(departure_airport) dept_flight_count
from bookings.flights bf
group by 1) as dept
join bookings.airports_data ad
on ad.airport_code = dept.departure_airport
order by 2 desc
limit 1

--How many flights from ‘DME’ airport don’t have actual departure?

select count(distinct flight_no)
from bookings.flights
where departure_airport = 'DME' and actual_departure is null

--Identify flight ids having range between 3000 to 6000

select bf.flight_id
from bookings.flights bf
join (select aircraft_code
from bookings.aircrafts_data
where aircrafts_data.range between 3000 and 6000) as table1
on bf.aircraft_code = table1.aircraft_code

--Write a query to get the count of flights flying between URS and KUF?

select count(distinct flight_no)
from bookings.flights
where departure_airport = 'URS' and arrival_airport = 'KUF'

--Write a query to get the count of flights flying from KZN, DME, NBC,NJC,GDX,SGC,VKO,ROV

select count(distinct flight_no)
from bookings.flights
where departure_airport in ('KZN', 'DME', 'NBC', 'NJC', 'GDX', 'SGC', 'VKO', 'ROV')

--Write a query to extract flight details having range between 3000 and 6000 and flying from DME

select *
from bookings.flights bf
join (select aircraft_code
from bookings.aircrafts_data
where aircrafts_data.range between 3000 and 6000) as table1
on bf.aircraft_code = table1.aircraft_code
where bf.departure_airport = 'DME'

--Find the list of flight ids which are using aircrafts from “Airbus” company and got cancelled or delayed

select flight_id
from bookings.flights bf
join (select aircraft_code
from bookings.aircrafts_data
where model::text like '%Airbus%') as table1
on bf.aircraft_code = table1.aircraft_code
where status in ('Cancelled', 'Delayed')

--Which airport(name) has most cancelled flights (arriving)?

select ad.airport_name
from (select arrival_airport,
count(arrival_airport) airport_count
from bookings.flights
where status = 'Cancelled'
group by 1) as table1
join bookings.airports_data ad
on table1.arrival_airport = ad.airport_code
order by airport_count desc
limit 1

--Identify flight ids which are using “Airbus aircrafts”

select flight_id
from bookings.flights bf
join (select aircraft_code
from bookings.aircrafts_data
where model::text like '%Airbus%') as table1
on bf.aircraft_code = table1.aircraft_code

--Identify date-wise last flight id flying from every airport?

select flight_id
from (select flight_id,
departure_airport,
scheduled_departure,
dense_rank() over(partition by departure_airport order by scheduled_departure desc) dns_rank
from bookings.flights) as table1
where dns_rank = 1

--Identify list of customers who will get the refund due to cancellation of the flights? And how much amount they will get?

select bf.flight_id,
bs.fare_conditions,
bs.seat_no
from bookings.flights bf
join bookings.seats bs
on bs.aircraft_code = bf.aircraft_code
where status = 'Cancelled'

--Identify date wise first cancelled flight id flying for every airport?

select flight_id
from (select *,
dense_rank() over(partition by departure_airport order by scheduled_departure) dns_rank
from bookings.flights
where status = 'Cancelled') as table1
where dns_rank = 1

--Identify list of Airbus flight ids which got cancelled.

select flight_id
from bookings.flights bf
join (select aircraft_code
from bookings.aircrafts_data
where model::text like '%Airbus%') as table1
on bf.aircraft_code = table1.aircraft_code
where status = 'Cancelled'

--Identify list of flight ids having highest range.

select bf.flight_id
from bookings.flights bf
join (select *
from bookings.aircrafts_data
order by range desc
limit 1) as table1
on bf.aircraft_code = table1.aircraft_code