CREATE INDEX idx_properties_location ON properties(location);
CREATE INDEX idx_properties_name ON properties(name);

EXPLAIN ANALYZE
SELECT u.first_name, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.first_name
ORDER BY total_bookings DESC;
