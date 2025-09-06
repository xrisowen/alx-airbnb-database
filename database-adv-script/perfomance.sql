-- Retrieve bookings with user, property, and payment details.
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
