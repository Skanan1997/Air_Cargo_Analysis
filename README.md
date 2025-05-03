
# 📊 Air Cargo Analysis

## 🚀 Project Overview

**Project Title:** Air Cargo Analysis
**Level:** Intermediate
**Database:** Air\_Cargo\_Analysis\_P2

This SQL project simulates a real-world airline business scenario, focusing on air transportation services for passengers and freight. The primary goal is to analyze operational and customer-related data for improving service quality, ticket sales efficiency, route management, and passenger experience.

Designed for budding data analysts, this project helps demonstrate proficiency in database creation, data manipulation, and advanced SQL queries through stored procedures, functions, views, and optimizations.

---

## 🎯 Objectives

* Identify frequent customers for loyalty rewards.
* Analyze busiest air routes to optimize aircraft allocation.
* Evaluate ticket sales by class and service brand.
* Use SQL queries, procedures, and views to extract actionable business insights.

---

## 🗂️ Project Structure

### 1. Database & Table Setup

* **Database Creation**

  ```sql
  CREATE DATABASE Air_Cargo_Analysis_P2;
  ```

* **Table Overview:**

  * `customer`: Stores customer demographics.
  * `passengers_on_flights`: Tracks passengers’ travel data.
  * `ticket_details`: Contains ticket booking and payment data.
  * `routes`: Details flight routes and travel distance.

---

### 2. Data Exploration & Cleaning

* Retrieve total customers, routes, and check for null values.
* Sample queries:

  ```sql
  SELECT COUNT(*) FROM customer;
  SELECT DISTINCT route_id FROM routes;
  SELECT * FROM ticket_details WHERE price_per_ticket IS NULL;
  ```

---

### 3. Business Analysis Queries

* **Frequent Route Passengers**

  ```sql
  SELECT * FROM passengers_on_flights WHERE route_id BETWEEN 1 AND 25;
  ```

* **Business Class Revenue**

  ```sql
  SELECT class_id, COUNT(*) AS passenger_count, SUM(price_per_ticket * no_of_tickets) AS total_revenue 
  FROM ticket_details WHERE class_id = 'Business' GROUP BY class_id;
  ```

* **Customer Full Name**

  ```sql
  SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM customer;
  ```

* **Registered & Booked Customers**

  ```sql
  SELECT DISTINCT c.customer_id, c.first_name, c.last_name
  FROM customer c
  JOIN ticket_details t ON c.customer_id = t.customer_id;
  ```

* **Emirates Customers**

  ```sql
  SELECT c.first_name, c.last_name 
  FROM customer c
  JOIN ticket_details t ON c.customer_id = t.customer_id
  WHERE brand = 'Emirates';
  ```

---

### 4. Advanced SQL (Stored Procedures, Views, Window Functions)

* **View for Business Class Flyers**

  ```sql
  CREATE VIEW business_class_customers AS
  SELECT customer_id, brand
  FROM ticket_details
  WHERE class_id = 'Business';
  ```

* **Stored Procedure: Distance Categories**

  ```sql
  DELIMITER $$
  CREATE PROCEDURE GroupDistanceByFlight()
  BEGIN
      SELECT route_id, flight_num, distance_miles,
          CASE 
              WHEN distance_miles <= 2000 THEN 'SDT'
              WHEN distance_miles <= 6500 THEN 'IDT'
              ELSE 'LDT'
          END AS distance_category
      FROM routes;
  END$$
  DELIMITER ;
  ```

* **Stored Procedure: Distance > 2000**

  ```sql
  DELIMITER $$
  CREATE PROCEDURE GetLongDistanceRoutes()
  BEGIN
      SELECT * FROM routes WHERE distance_miles > 2000;
  END$$
  DELIMITER ;
  ```

* **Stored Procedure with Stored Function (Complimentary Services)**

  ```sql
  DELIMITER $$
  CREATE FUNCTION GetComplimentary(class VARCHAR(50))
  RETURNS VARCHAR(3)
  DETERMINISTIC
  BEGIN
      RETURN IF(class IN ('Business', 'Economy Plus'), 'Yes', 'No');
  END$$
  DELIMITER ;

  DELIMITER $$
  CREATE PROCEDURE CheckComplimentaryServices()
  BEGIN
      SELECT p_date, customer_id, class_id,
             GetComplimentary(class_id) AS complimentary_service
      FROM ticket_details;
  END$$
  DELIMITER ;
  ```

---

## 📈 Findings & Insights

* **Frequent Flyers**: Identified for loyalty and personalized offers.
* **Route Performance**: Busiest routes help optimize aircraft deployment.
* **Revenue Trends**: Class-wise and brand-wise revenue insights help pricing strategy.
* **Customer Preferences**: Emirates and Business class preferred among premium customers.

---

## 📊 Reports & Dashboards

* **Revenue Report**: Per class and per brand.
* **Customer Report**: Loyalty, preferences, and demographics.
* **Route Analysis**: Best and least performing routes.

---

## ✅ Conclusion

This project showcases a strong application of SQL for real-world business problems in the aviation domain. It touches upon data modeling, cleaning, analysis, stored logic, and performance optimization. Ideal for showcasing in a portfolio or preparing for data analyst roles.

---

### ✍️ Author Kanan Sangeet
*Aspiring Data Analyst*

If you have any questions, feedback, or collaboration opportunities, feel free to reach out!

