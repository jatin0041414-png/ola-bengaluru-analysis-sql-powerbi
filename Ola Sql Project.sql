use ola
---Retrieve all successful bookings---
select * from [Bengaluru Ola]
where Booking_Status='Success'

---Find the average ride distance for each vehicle type---
select vehicle_type,cast(avg(ride_distance) as decimal(10,2)) as avg_ride_distance from [Bengaluru Ola]
group by Vehicle_Type
order by avg_ride_distance desc;

--- Get the total number of cancelled rides by customers---
select count(*) as customer_cancellaton_count from [Bengaluru Ola]
where booking_status = 'cancelled by customer'

--- List the top 5 customers who booked the highest number of rides---
select top 5 Customer_ID,count(*) rides_count from [Bengaluru Ola]
group by customer_id
order by rides_count desc;

---Get the number of rides cancelled by drivers due to personal and car-related issues---
select count(*) as driver_cancellation from [Bengaluru Ola]
where Reason_for_Cancelling_by_Driver='Personal & car related issues'

--- Find the maximum and minimum driver ratings for Prime Sedan bookings--
Select max(driver_ratings) as max_driver_rating,
       min(driver_ratings) as min_driver_rating from [Bengaluru Ola]
where Vehicle_Type='Prime Sedan';

--- Retrieve all rides where payment was made using UPI---
select * from [Bengaluru Ola]
where Payment_Method='UPI'

---Find the average customer rating per vehicle type---
select vehicle_type,cast(avg(Customer_Rating) as decimal(10,2)) as Avg_Cust_ratings from [Bengaluru Ola]
group by Vehicle_Type;

--- Calculate the total booking value of rides completed successfully---
select  cast(sum(booking_value) as decimal(10,2)) as  total_revenue from [Bengaluru Ola]
where Booking_Status='Success';

---List all incomplete rides along with the reason---
select booking_id,Incomplete_Rides_Reason from [Bengaluru Ola]
where Incomplete_Rides='1';

---Count the total number of bookings.
select count(*) as total_booking from [Bengaluru Ola]

---Count bookings by booking status
select Booking_Status,count(*) as no_of_bookings from [Bengaluru Ola]
group by Booking_Status

---Calculate total booking value for successful rides.
select sum(booking_value) as revenue from [Bengaluru Ola]
where Booking_Status='success'

---Calculate average booking value by vehicle type.
select vehicle_type,cast(avg(booking_value) as decimal(10,3)) avg_booking_value from [Bengaluru Ola]
group by Vehicle_Type
order by avg_booking_value desc;

---Find the highest and lowest booking values.
select cast(max(booking_value) as decimal(10,2)) as highest_booking_value,cast(min(booking_value) as decimal(10,2)) as lowest_booking_value from [Bengaluru Ola]
  
---Find the number of bookings for each payment method.
select payment_method,count(*) as no_of_bookings from [Bengaluru Ola]
where Payment_Method is not null
group by Payment_Method
order by no_of_bookings desc

---Find vehicle types with more than 1,000 bookings.
select vehicle_type,count(*) as no_of_bookings from [Bengaluru Ola]
group by Vehicle_Type
having count(*) > 1000
order by no_of_bookings desc

---Find the top 5 customers by total successful booking value.
select top 5 Customer_ID,cast(SUM(booking_value)as decimal(10,2)) as total_successful_booking_value from [Bengaluru Ola]
where Booking_Status='success'
group by Customer_ID
order by total_successful_booking_value desc;

---Calculate average ride distance by vehicle type for successful rides.
select Vehicle_Type,cast(AVG(ride_distance) as decimal(10,2)) avg_distance from [Bengaluru Ola]
where Booking_Status='success'
group by Vehicle_Type
order by avg_distance desc;

---Find the five most common pickup locations among successful rides.
select top 5 Pickup_Location,count(*) as no_of_booking from [Bengaluru Ola]
where Booking_Status='success'
group by Pickup_Location
order by no_of_booking desc;

---Create a new column that classifies bookings as Successful, Cancelled, Incomplete or Other
select case
   when booking_status= 'success' then 'successful'
   when booking_status= 'cancelled by customer'
    or Booking_Status= 'cancelled by driver'  then 'cancelled'
   when Booking_Status= 'incomplete' then 'incomplete'
   else 'other'
   end as booking_category
from [Bengaluru Ola]

---Calculate the percentage of bookings in each status.
select booking_status,count(*) as total_bookings,
cast(count(*) * 100.0/Sum(count(*)) over() as decimal(5,2)) as Booking_Percentage
from [Bengaluru Ola]
group by Booking_Status
order by Booking_Percentage desc;

---Find records where Driver Ratings are missing
select * from [Bengaluru Ola]
where Driver_Ratings is null

---Display vehicle types in uppercase
select distinct(upper(vehicle_type)) as Vehicle_Type  from [Bengaluru Ola]

---Replace missing rating values with a label such as 'Not Rated' in the output
select cast(customer_rating as decimal(10,1)) as customer_rating,
    ISNULL(cast(Customer_Rating as varchar(20)),'Not Rated') as rating_label
from [Bengaluru Ola]

---Classify successful rides as Short (under 5 km), Medium (5–15 km) or Long (over 15 km)
select Ride_Distance,case
     when Ride_Distance <5 then 'short'
     when Ride_Distance >=5 and Ride_Distance<=15 then 'Medium'
     when Ride_Distance >15 then 'Long'
     else 'other'
     end as Booking_classification
from [Bengaluru Ola]
where booking_status='success'

---Extract the month and year from the booking date
select Date,datepart(year,Date) as year_,
DATEPART(month,Date) as month_
from [Bengaluru Ola]

---Calculate the average ride distance for successful and unsuccessful bookings separately.
SELECT
    AVG(CASE
            WHEN booking_status = 'Success'
            THEN ride_distance
        END) AS Avg_Successful_Distance,
    AVG(CASE
            WHEN booking_status <> 'Success'
                 AND booking_status IS NOT NULL
            THEN ride_distance
        END) AS Avg_Unsuccessful_Distance
FROM [Bengaluru Ola];

---Identify bookings where the booking value is missing or zero
select booking_id,booking_value from [Bengaluru Ola]
where Booking_value is null or Booking_Value= 0

---Find bookings whose value is greater than the overall average booking value
select booking_id,booking_value from [Bengaluru Ola]
where Booking_Value > (select avg(booking_value) from [Bengaluru Ola])

---Find vehicle types whose average booking value exceeds the overall average
select vehicle_type,avg(booking_value) as avg_value from [Bengaluru Ola]
group by Vehicle_Type
having avg(booking_value)>(select avg(booking_value) from [Bengaluru Ola])

---Find customers whose total successful booking value exceeds the average customer total
with cts as
(select 
    customer_id,
    cast(sum(booking_value)as decimal(10,2)) as Total_successful_value
from [Bengaluru Ola]
where booking_status='success'
group by customer_id)
select 
    customer_id,
    Total_successful_value
from cts
where Total_successful_value > (select avg(total_successful_value) from cts)
order by Total_successful_value desc;

---Find pickup locations with more successful bookings than the average number of successful bookings per pickup location
with successful_booking as(
select pickup_location,count(*) as no_of_bookings from [Bengaluru Ola]
where Booking_Status='success'
group by Pickup_Location)
select pickup_location,
       no_of_bookings
from successful_booking
where no_of_bookings > (select avg(no_of_bookings) from successful_booking)
order by no_of_bookings desc;

---Find the vehicle type with the highest average ride distance
with vehicle as(
select vehicle_type,
       cast(avg(Ride_Distance)as decimal(10,2)) as avg_dist
from [Bengaluru Ola]
group by Vehicle_Type)
select vehicle_type,
       avg_dist
from vehicle
where avg_dist = (select MAX(avg_dist) from vehicle)
order by avg_dist desc;

---Find the highest-value successful booking for each vehicle type
select  
      booking_id,
      vehicle_type,
      booking_value
from ( 
      select 
           booking_id,
           vehicle_type,
           booking_value,
           row_number() over(partition by vehicle_type
           order by booking_value desc,booking_id)as rn
       from [Bengaluru Ola]
       where booking_status='success')as ranked_bookings
where rn=1
order by booking_value desc;

select distinct booking_status from [Bengaluru Ola] ---remove

---Calculate customer cancellation and driver cancellation counts in a single result
select 
    count(case when booking_status='cancelled by customer' then 1 end) as 'cancelled_by_customer_count',
    count(case when booking_status='cancelled by driver' then 1 end) as 'cancelled_by_driver_count'
 from [Bengaluru Ola]

---Find booking IDs that appear more than once
select booking_id,count(*) booking_count from [Bengaluru Ola]
group by Booking_ID
having count(*) >1;

---Use a CTE to calculate total successful revenue by vehicle type and return the top three
with sr as(
select vehicle_type,cast(sum(booking_value)as decimal(10,2)) as successful_revenue from [Bengaluru Ola]
where Booking_Status='success'
group by Vehicle_Type)
select top 3
vehicle_type,successful_revenue from sr 
order by successful_revenue desc;

---Display customer ID, booking value, and rank from highest to lowest booking value.
select customer_id,Booking_ID,cast((booking_value) as decimal(10,2)) as booking_value,
rank() over( Order by booking_value desc) as booking_rank
from [Bengaluru Ola]

---Number every booking in descending order of booking value.
select customer_id,booking_value,
row_number() over(order by booking_value desc) as row_num
from [Bengaluru Ola]

---Calculate the average booking value for each vehicle type and rank them.
with va as(
select 
      vehicle_type,
      avg(booking_value) as avg_booking_value
      from [Bengaluru Ola]
      group by Vehicle_Type)
select 
     vehicle_type,
     avg_booking_value,
     rank() over(order by avg_booking_value desc) as vehicle_rank
from va

---Display all three ranking functions for booking values.
select 
    customer_id,
    booking_value,
    row_number() over( order by booking_value desc) as row_num,
    rank() over(order by booking_value desc) as booking_rank,
    dense_rank() over( order by booking_value desc) as dense_rank_
from [Bengaluru Ola]

