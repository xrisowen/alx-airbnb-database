# Optimization Report

## Initial Query (Unoptimized)
The initial query retrieved all bookings along with user, property, and payment details using multiple INNER JOINs.  
Issue:

```sql
-- Initial complex query to fetch bookings with user, property, and payment details
SELECT 
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    p.id AS property_id,
    p.name AS property_name,
    p.location,
    pay.id AS payment_id,
    pay.amount,
    pay.status,
    pay.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id
ORDER BY b.start_date DESC;
```

## Analyze Performance

```sql
EXPLAIN ANALYZE
SELECT 
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    p.id AS property_id,
    p.name AS property_name,
    p.location,
    pay.id AS payment_id,
    pay.amount,
    pay.status,
    pay.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id
ORDER BY b.start_date DESC;
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
