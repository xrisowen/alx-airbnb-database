-- ==========================
-- Insert Users
-- ==========================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
(gen_random_uuid(), 'Alice', 'Johnson', 'alice@example.com', 'hashed_pw1', '08011112222', 'guest'),
(gen_random_uuid(), 'Bob', 'Williams', 'bob@example.com', 'hashed_pw2', '08033334444', 'host'),
(gen_random_uuid(), 'Clara', 'Smith', 'clara@example.com', 'hashed_pw3', '08055556666', 'host'),
(gen_random_uuid(), 'David', 'Brown', 'david@example.com', 'hashed_pw4', '08077778888', 'admin');

-- ==========================
-- Insert Properties
-- (hosted by Bob and Clara)
-- ==========================
INSERT INTO properties (property_id, host_id, name, description, location, pricepernight)
SELECT gen_random_uuid(), user_id, 'Cozy Apartment', '2 bedroom apartment in city center', 'Lagos', 80.00
FROM users WHERE email = 'bob@example.com';

INSERT INTO properties (property_id, host_id, name, description, location, pricepernight)
SELECT gen_random_uuid(), user_id, 'Beach Villa', 'Luxury villa near the beach', 'Accra', 200.00
FROM users WHERE email = 'clara@example.com';

-- ==========================
-- Insert Bookings
-- (Alice books Bob’s apartment and Clara’s villa)
-- ==========================
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-09-01', '2025-09-05', 320.00, 'confirmed'
FROM properties p, users u
WHERE p.name = 'Cozy Apartment' AND u.email = 'alice@example.com';

INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-10-10', '2025-10-15', 1000.00, 'pending'
FROM properties p, users u
WHERE p.name = 'Beach Villa' AND u.email = 'alice@example.com';

-- ==========================
-- Insert Payments
-- ==========================
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
SELECT gen_random_uuid(), b.booking_id, 320.00, 'credit_card'
FROM bookings b
JOIN properties p ON b.property_id = p.property_id
WHERE p.name = 'Cozy Apartment';

-- ==========================
-- Insert Reviews
-- ==========================
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
SELECT gen_random_uuid(), p.property_id, u.user_id, 5, 'Amazing stay, very comfortable!'
FROM properties p, users u
WHERE p.name = 'Cozy Apartment' AND u.email = 'alice@example.com';

INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
SELECT gen_random_uuid(), p.property_id, u.user_id, 4, 'Beautiful villa but a bit pricey.'
FROM properties p, users u
WHERE p.name = 'Beach Villa' AND u.email = 'alice@example.com';

-- ==========================
-- Insert Messages
-- ==========================
-- Alice (guest) sends message to Bob (host)
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
SELECT gen_random_uuid(), u1.user_id, u2.user_id, 'Hi Bob, is the apartment available for early check-in?'
FROM users u1, users u2
WHERE u1.email = 'alice@example.com' AND u2.email = 'bob@example.com';

-- Bob replies
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
SELECT gen_random_uuid(), u1.user_id, u2.user_id, 'Yes Alice, you can check in at 10 AM.'
FROM users u1, users u2
WHERE u1.email = 'bob@example.com' AND u2.email = 'alice@example.com';
