CREATE TABLE ola_bookings_data (
    date TIMESTAMP,
    time TIME,
    booking_id VARCHAR(20),
    booking_status VARCHAR(10),
    customer_id VARCHAR(20),
    vehicle_type VARCHAR(20),
    pickup_location VARCHAR(50),
    drop_location VARCHAR(50),
    v_tat INT,
    c_tat INT,
    incomplete_rides BOOLEAN,
    incomplete_rides_reason VARCHAR(50),
    booking_value INT,
    payment_method VARCHAR(20),
    ride_distance INT,
    driver_ratings DECIMAL(2, 1),
    customer_rating DECIMAL(2, 1)
);

Select * from ola_bookings_data

Select count(*) from ola_bookings_data

-- 1. Retrieve all successful bookings:
Select 
	*
from ola_bookings_data
where booking_status = 'Success'

-- 2. Find the average ride distance for each vehicle type:
select
	vehicle_type,
	avg(ride_distance) as avg_ride_dist
from ola_bookings_data
group by vehicle_type
order by avg(ride_distance)desc

-- 3. List the top 5 customers who booked the highest number of rides:
select
	customer_id,
	count(booking_id) as total_book_ride
from ola_bookings_data
group by customer_id
order by count(booking_id)desc

-- 5. How many rides were marked as incomplete for each distinct reason in the ola_bookings_data table?
select 
	incomplete_rides_reason,
	count(*) as total_incomplete_rides
from ola_bookings_data
group by incomplete_rides_reason

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
select
	vehicle_type,
	max(driver_ratings) as max_ratings,
	min(driver_ratings) as min_ratings
from ola_bookings_data
group by vehicle_type 
having vehicle_type = 'Prime Sedan'

-- 7. Retrieve all rides where payment was made using UPI:
select
*
from ola_bookings_data
where payment_method = 'UPI'

-- 8. Find the average customer rating per vehicle type:
select
	vehicle_type,
		avg(customer_rating) as avg_customer_ratings
from ola_bookings_data
group by vehicle_type

-- 9. Calculate the total booking value of rides completed successfully:
select 
	sum(booking_value) 
from ola_bookings_data
where booking_status = 'Success'

-- 10. List all incomplete rides along with the reason:
select * from ola_bookings_data
select 
	booking_id,
	incomplete_rides_reason
from ola_bookings_data
where incomplete_rides =true

-- Creating View For This all queries ---
-- 1. Retrieve all successful bookings:
Create View Successfull_Bookings as
Select 
	*
from ola_bookings_data
where booking_status = 'Success'

select * from Successfull_Bookings


-- -- Ola Ride Analysis: SQL-Driven Insights for Peak Efficiency and Revenue Optimization ---
select * from ola_bookings_data
-- 1. Monthly Revenue Trend
-- Question: What is the monthly trend of booking revenue?
-- Insight: Identify high-revenue months to strategize marketing campaigns.
SELECT
	TO_CHAR(DATE,'YYYY-MM') AS month,
	SUM(BOOKING_VALUE) as TOTAL_VALUE
FROM OLA_BOOKINGS_DATA
GROUP BY TO_CHAR(DATE,'YYYY-MM')
ORDER BY TO_CHAR(DATE,'YYYY-MM')

-- 2. Top 5 Vehicle Types by Revenue
-- Question: Which vehicle types generate the most revenue?
-- Insight: Focus on popular vehicle types for increasing fleet size or promotions.
SELECT
	VEHICLE_TYPE,
	SUM(BOOKING_VALUE) AS TOTAL_REVENUE
FROM OLA_BOOKINGS_DATA
GROUP BY VEHICLE_TYPE
ORDER BY SUM(BOOKING_VALUE) DESC
LIMIT 5

-- 3. Incomplete Ride Analysis
-- Question: What are the reasons for incomplete rides?
-- Insight: Address major issues causing incomplete rides to improve service.

SELECT
	INCOMPLETE_RIDES_REASON,
	COUNT(*) as OCCURANCE
FROM OLA_BOOKINGS_DATA
WHERE INCOMPLETE_RIDES = true
GROUP BY INCOMPLETE_RIDES_REASON
ORDER BY COUNT(*) DESC

-- 4. Revenue by Payment Method
-- Question: Which payment method contributes most to revenue?
-- Insight: Optimize the user experience for the most popular payment methods.
SELECT
	PAYMENT_METHOD,
	SUM(BOOKING_VALUE) AS TOTAL_REVENUE
FROM OLA_BOOKINGS_DATA
GROUP BY PAYMENT_METHOD
ORDER BY SUM(BOOKING_VALUE) DESC

-- 5. Driver Performance
-- Question: Who are the top 5 drivers based on average ratings?
-- Insight: Reward high-performing drivers to encourage service quality.
SELECT 
	DRIVER_RATINGS,
	COUNT(BOOKING_ID) AS RIDES_HANDLE,
	AVG(CUSTOMER_RATING) AS AVG_CUST_RATINGS
FROM OLA_BOOKINGS_DATA
GROUP BY DRIVER_RATINGS
ORDER BY AVG_CUST_RATINGS DESC , COUNT(BOOKING_ID) DESC
LIMIT 5


-- 6. Ride Distance Analysis
-- Question: What is the revenue contribution by ride distance categories?
-- Insight: Understand trip profitability across various distance ranges.
SELECT
	CASE WHEN RIDE_DISTANCE <=10 THEN 'Short Distance (0-10 km)'
         WHEN RIDE_DISTANCE BETWEEN 11 AND 30 THEN  'Medium Distance (11-30 km)'
		 ELSE 'Long Distance (>30 km)' 
	END AS DISTANCE_CATEGORY,
	SUM(BOOKING_VALUE) AS TOTAL_REVENUE
FROM OLA_BOOKINGS_DATA
GROUP BY DISTANCE_CATEGORY
ORDER BY TOTAL_REVENUE DESC


-- 7. Customer Retention
-- Question: How many rides were taken by each customer?
-- Insight: Identify loyal customers and target them for exclusive offers.
SELECT
	CUSTOMER_ID,
	COUNT(BOOKING_ID) AS TOTAL_RIDES,
	SUM(BOOKING_VALUE) AS TOTAL_SPENT
FROM OLA_BOOKINGS_DATA
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_RIDES DESC , TOTAL_SPENT DESC


-- 8. Peak Booking Hours
-- Question: When are the peak hours for bookings?
-- Insight: Align driver availability with demand during peak hours.

-- If 8 AM (or any specific hour) appears as the peak hour in the query result, 
-- this indicates that 8 AM is the peak hour when the demand for rides is the highest.

-- Business Recommendation:

-- Deploy More Vehicles: Increase the availability of vehicles (e.g., autos, bikes, and premium cars) 
-- during this hour to meet the high demand and reduce wait times for customers.

-- Dynamic Pricing: Consider implementing surge pricing during peak hours to maximize revenue 
-- while managing demand effectively.

-- Driver Incentives: Offer bonuses or incentives to drivers for being available during peak hours,
-- ensuring sufficient vehicle availability.

SELECT 
	EXTRACT(HOUR FROM DATE) AS HOUR,
	COUNT(BOOKING_ID) AS RIDE_COUNT
FROM OLA_BOOKINGS_DATA
GROUP BY EXTRACT(HOUR FROM DATE)
ORDER BY RIDE_COUNT DESC

-- 9. Vehicle Type Efficiency
-- Question: What is the average completion time (C_TAT) for each vehicle type?
-- Insight: Optimize routes for vehicle types with higher completion times.
SELECT
	VEHICLE_TYPE,
	ROUND(AVG(C_TAT),2) AS AVG_COMPLETION_TIME
FROM OLA_BOOKINGS_DATA
GROUP BY VEHICLE_TYPE
ORDER BY ROUND(AVG(C_TAT),2) DESC

-- 10. What is the impact of vehicle type on average completion time (C_TAT) 
-- and total revenue across different distance categories?
-- Insight:

-- Completion Time Analysis: Compare the efficiency of different vehicle types for various ride distances. 
-- For instance, shorter distances might show lower completion times for vehicles like "Auto" or "Bike."

-- Revenue Impact: Identify which vehicle types contribute the most revenue in each distance category. 
-- For example, "Prime SUVs" might dominate long-distance rides in terms of revenue.

-- Business Strategy: Optimize vehicle deployment based on completion times and revenue patterns. 
-- If a particular vehicle type is inefficient for short or medium rides, 
-- reassign those vehicles to routes with higher profitability.

SELECT
  VEHICLE_TYPE,
  CASE 
    WHEN RIDE_DISTANCE <= 10 THEN 'Short Distance (0-10 km)'
    WHEN RIDE_DISTANCE BETWEEN 11 AND 30 THEN 'Medium Distance (11-30 km)'
    ELSE 'Long Distance (>30 km)' 
  END AS DISTANCE_CATEGORY,
  ROUND(AVG(C_TAT), 2) AS AVG_COMPLETION_TIME,
  SUM(BOOKING_VALUE) AS TOTAL_REVENUE
FROM OLA_BOOKINGS_DATA
GROUP BY VEHICLE_TYPE,DISTANCE_CATEGORY
ORDER BY DISTANCE_CATEGORY, TOTAL_REVENUE DESC;
