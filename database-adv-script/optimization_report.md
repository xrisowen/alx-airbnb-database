# Optimization Report

## Initial Query (Unoptimized)
The initial query retrieved all bookings along with user, property, and payment details using multiple INNER JOINs.  
Issue:

```sql
--- Retrieve bookings with user, property, and payment details.
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_title,
    p.location AS property_location,
    py.payment_id,
    py.amount AS payment_amount,
    py.payment_date
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
LEFT JOIN 
    payments py 
    ON b.booking_id = py.booking_id;
```

## Analyze Performance

```sql

--Analyze the query’s performance using EXPLAIN and identify any inefficiencies.
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_title,
    p.location AS property_location,
    py.payment_id,
    py.amount AS payment_amount,
    py.payment_date
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
LEFT JOIN 
    payments py 
    ON b.booking_id = py.booking_id;
```

- **Performance Analysis: -** Using EXPLAIN ANALYZE, we observed:
    - Seq Scan (Sequential Scan) on large tables → slow for big datasets.
    - Nested Loop joins with large row counts → inefficient.

## Optimized Query

- **Refactored the query:**
    - Reduce unnecessary columns
      Select only the required ones.
    - Avoid unnecessary joins
      Payments are rarely queried, fetch them separately instead of joining every time.

```sql
--Refactored Query (Optimized)
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name || ' ' || u.last_name AS user_full_name,
    p.name AS property_title,
    py.amount AS payment_amount,
    py.status AS payment_status
FROM 
    bookings b
JOIN 
    users u 
    ON b.user_id = u.user_id
JOIN 
    properties p 
    ON b.property_id = p.property_id
LEFT JOIN 
    payments py 
    ON b.booking_id = py.booking_id;
```

- **Results**
    - This version reduces data transfer by avoiding extra columns.
    - With proper indexes, it should run significantly faster.
