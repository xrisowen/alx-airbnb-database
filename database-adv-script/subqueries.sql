--Properties with average rating > 4.0 (subquery)
SELECT 
    p.property_id,
    p.name,
    p.location
FROM 
    properties p
WHERE 
    (SELECT AVG(r.rating) 
     FROM reviews r 
     WHERE r.property_id = p.property_id) > 4.0;
	 
--Users with more than 3 bookings (correlated subquery)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    users u
WHERE 
    (SELECT COUNT(*) 
     FROM bookings b 
     WHERE b.user_id = u.user_id) > 3;
