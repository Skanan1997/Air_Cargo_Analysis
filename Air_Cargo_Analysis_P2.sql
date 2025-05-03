create database airlines;
use airlines;

Select * from customer;
Select * from passengers_on_flights;
Select * from routes;
Select * from ticket_details;


/* 1. Create an ER diagram for the given airlines database. */


/* 2. Write a query to create a route_details table using suitable data types for the fields, 
such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles.
 Implement the check constraint for the flight number and unique constraint for the route_id fields. 
 Also, make sure that the distance miles field is greater than 0. */ 
 
 Create table route_details
 (route_id int NOT NULL UNIQUE,
 flight_num varchar(20) NOT NULL,
 origin_airport varchar(100) NOT NULL,
 destination_airport varchar(100) NOT NULL ,
 aircraft_id int NOT NULL ,
 distance_miles int NOT NULL
 
-- Constraints
    CONSTRAINT chk_distance CHECK (distance_miles > 0),

    PRIMARY KEY (route_id)
);
 
/* 3. Write a query to display all the passengers (customers) who have travelled 
in routes 01 to 25. Take data from the passengers_on_flights table. */

Select customer_id,route_id
From passengers_on_flights
where route_id between 01 and 25;


/* 4. Write a query to identify the number of passengers and total revenue in business class 
from the ticket_details table. */
select * From ticket_details;

Select class_id,
count(distinct customer_id) as Total_customer,
Sum(Price_per_ticket) as total_revenue
From ticket_details
where class_id = 'Bussiness'
Group By class_id;

/* 5. Write a query to display the full name of the customer by 
extracting the first name and last name from the customer table. */

select * from customer;

SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;


/* 6. Write a query to extract the customers who have registered 
and booked a ticket. Use data from the customer and ticket_details tables. */

Select * from ticket_details;
select * from customer;

Select c.customer_id,
concat(c.first_name, ' ', c.last_name) as full_name,
t.aircraft_id,
t.price_per_ticket
from customer as c
join ticket_details as t on c.customer_id = t.customer_id;

/* 7. Write a query to identify the customer’s first name and last name
 based on their customer ID and brand (Emirates) from the ticket_details table. */
 
 select c.customer_id, c.first_name, c.last_name, t.brand
 From customer as c 
 join ticket_details as t on c.customer_id = t.customer_id
 where brand = 'Emirates';
 
 
/* 8. Write a query to identify the customers who have travelled by Economy Plus
 class using Group By and Having clause on the passengers_on_flights table. */
 
select customer_id
from passengers_on_flights
group by customer_id
having sum(class_id = 'Economy Plus')>0;
 
 
/* 9. Write a query to identify whether the revenue has crossed 10000 using 
the IF clause on the ticket_details table.  */

select * from ticket_details;

-- by sum function
select sum(Price_per_ticket)
from ticket_details;

-- by if clause
Select 
     sum(Price_per_ticket) as Total_Revenue,
     If(sum(Price_per_ticket) > 10000, 'Revenue > 10000' , 'Revenue <= 10000') As Revenue_Status
     from ticket_details;
     
/* 10. Write a query to create and grant access to a new user to perform operations on a database. */

CREATE USER 'Kanan_user'@'Local_instance_3306' IDENTIFIED BY 'Report123!';
GRANT SELECT, INSERT, UPDATE ON airlines_db.* TO 'Kanan_user'@'Local_instance_3306';
FLUSH PRIVILEGES;


/* 11.	Write a query to find the maximum ticket price for each class using
 window functions on the ticket_details table. */
 
 Select *  From ticket_details;
 
 Select class_id,
 Max(Price_per_ticket)
 From ticket_details
 Group BY class_id;
 
 
/* 12.	Write a query to extract the passengers whose route ID is 4 by
 improving the speed and performance of the passengers_on_flights table.  */
 
  Select *  From passengers_on_flights;
 
 Select customer_id,route_id
 from passengers_on_flights
  where route_id = 4;
 
 /* 13. For the route ID 4, write a query to view the execution plan of the
 passengers_on_flights table. */
 
 
 EXPLAIN
SELECT *
FROM passengers_on_flights
WHERE route_id = 4;

 /* 14.	Write a query to calculate the total price of all tickets booked by
 a customer across different aircraft IDs using rollup function. */
 
select aircraft_id,
sum(Price_per_ticket) As total_price
from ticket_details
group by aircraft_id WITH ROLLUP;
 
/* 15. Write a query to create a view with only business class customers 
along with the brand of airlines. */

 Select *  From ticket_details;

Select class_id,brand
From ticket_details
where class_id = 'Bussiness';


/* 16. Write a query to create a stored procedure to get the details of 
all passengers flying between a range of routes defined in run time. Also,
 return an error message if the table doesn't exist. */
 
 DELIMITER $$

CREATE PROCEDURE GetPassengers_By_RouteRange(IN start_route INT, IN end_route INT)
BEGIN
    -- Check if the table exists
    IF (SELECT COUNT(*)
        FROM information_schema.tables 
        WHERE table_schema = DATABASE() 
          AND table_name = 'passengers_on_flights') = 0 THEN
        -- Throw error if table doesn't exist
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table passengers_on_flights does not exist.';
    ELSE
        -- Fetch passenger details for the route range
        SELECT *
        FROM passengers_on_flights
        WHERE route_id BETWEEN start_route AND end_route;
    END IF;
END$$

DELIMITER ;



 
/* 17. Write a query to create a stored procedure that extracts all the details
 from the routes table where the travelled distance is more than 2000 miles. */
  
  
  Select * from routes;

 DELIMITER $$
 CREATE PROCEDURE GetLongRoutes()
BEGIN
 Select *
 from routes
 where distance_miles > 2000;
 END$$
 DELIMITER;
 
/* 18. Write a query to create a stored procedure that groups the distance 
travelled by each flight into three categories. The categories are, short 
distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel 
(IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.  */

Select * from routes;
Select distance_miles,  flight_num,

CASE
WHEN distance_miles >= 0 AND distance_miles <= 2000 THEN 'SDT'
            WHEN distance_miles > 2000 AND distance_miles <= 6500 THEN 'IDT'
            WHEN distance_miles > 6500 THEN 'LDT'
            ELSE 'Unknown'
        END AS distance_category
    FROM routes;

-- create a stored procedure


DELIMITER $$

CREATE PROCEDURE GroupDistanceByFlight()
BEGIN
    SELECT 
        flight_num,
        distance_miles,
        CASE
            WHEN distance_miles >= 0 AND distance_miles <= 2000 THEN 'SDT'
            WHEN distance_miles > 2000 AND distance_miles <= 6500 THEN 'IDT'
            WHEN distance_miles > 6500 THEN 'LDT'
            ELSE 'Unknown'
        END AS distance_category
    FROM routes;
END$$

DELIMITER ;



/* 19. Write a query to extract ticket purchase date, customer ID, class ID 
and specify if the complimentary services are provided for the specific class
 using a stored function in stored procedure on the ticket_details table. 
Condition: 
●	If the class is Business and Economy Plus, then complimentary services 
are given as Yes, else it is No. */



DELIMITER $$

CREATE FUNCTION CheckComplimentarys(className VARCHAR(50))
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3);
    IF className IN ('Business', 'Economy Plus') THEN
        SET result = 'Yes';
    ELSE
        SET result = 'No';
    END IF;
    RETURN result;
END$$

DELIMITER ;


/* 20. Write a query to extract the first record of the customer whose 
last name ends with Scott using a cursor from the customer table.  */

Select first_name,last_name
from customer
where last_name = 'Scott';

