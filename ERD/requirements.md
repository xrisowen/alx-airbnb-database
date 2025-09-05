### Entities and Relationships ER Diagram

<img width="1786" height="799" alt="Blank diagram (2)" src="https://github.com/user-attachments/assets/350fa76a-06d6-4c1d-a724-c55b0cc36257" />

#### ERD Specification

##### User
user_id PK, UUID, Indexed
first_name VARCHAR, NOT NULL
last_name VARCHAR, NOT NULL
email VARCHAR, UNIQUE, NOT NULL
password_hash VARCHAR, NOT NULL
phone_number VARCHAR, NULL
role ENUM('guest', 'host', 'admin'), NOT NULL
created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Constraints:
Unique constraint on email
NOT NULL on required fields

##### Property
property_id PK, UUID, Indexed
host_id FK → User(user_id)
name VARCHAR, NOT NULL
description TEXT, NOT NULL
location VARCHAR, NOT NULL
price_per_night DECIMAL, NOT NULL
created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

Constraints:
FK on host_id → User(user_id)
NOT NULL on essential attributes

##### Booking
booking_id PK, UUID, Indexed
property_id FK → Property(property_id)
user_id FK → User(user_id)
start_date DATE, NOT NULL
end_date DATE, NOT NULL
total_price DECIMAL, NOT NULL
status ENUM('pending', 'confirmed', 'canceled'), NOT NULL
created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Constraints:
FK on property_id, user_id
status limited to ENUM values

##### Payment
payment_id PK, UUID, Indexed
booking_id FK → Booking(booking_id)
amount DECIMAL, NOT NULL
payment_date TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
payment_method ENUM('credit_card', 'paypal', 'stripe'), NOT NULL

Constraints:
FK on booking_id → Booking(booking_id)

##### Review
review_id PK, UUID, Indexed
property_id FK → Property(property_id)
user_id FK → User(user_id)
rating INTEGER, CHECK rating BETWEEN 1 AND 5, NOT NULL
comment TEXT, NOT NULL
created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Constraints:
FK on property_id, user_id
Rating check: 1 ≤ rating ≤ 5

##### Message
message_id PK, UUID, Indexed
sender_id FK → User(user_id)
recipient_id FK → User(user_id)
message_body TEXT, NOT NULL
sent_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Constraints:
FK on sender_id, recipient_id → User(user_id)

##### Indexing
All Primary Keys → Indexed automatically
Additional indexes:
email in User
property_id in Property, Booking, Review
booking_id in Booking, Payment


#### Relationships
##### User ↔ Property
Relationship: One-to-Many
Explanation: A User with role = host can own many Properties, but each Property belongs to exactly one User (via host_id).

##### User ↔ Booking
Relationship: One-to-Many
Explanation: A User (guest) can make multiple Bookings. Each Booking belongs to exactly one User.

##### Property ↔ Booking
Relationship: One-to-Many
Explanation: A Property can have many Bookings (from different guests), but each Booking is tied to one Property.

##### Booking ↔ Payment
Relationship: One-to-One (or One-to-Many, depending on business logic)
Explanation: Each Payment must belong to a Booking. Usually, one Booking has one Payment, but if you allow partial payments, then it becomes One-to-Many.

##### User ↔ Review
Relationship: One-to-Many
Explanation: A User can write multiple Reviews. Each Review is tied to one User.

##### Property ↔ Review
Relationship: One-to-Many
Explanation: A Property can have multiple Reviews, but each Review is tied to one Property.

##### User ↔ Message
Relationship: One-to-Many (for both sender and recipient roles)
Explanation: A User can send many Messages (sender_id) and can also receive many Messages (recipient_id).

##### ✅ So, if we summarize:
User → Property = 1:N
User → Booking = 1:N
Property → Booking = 1:N
Booking → Payment = 1:1 (or 1:N)
User → Review = 1:N
Property → Review = 1:N
User → Message = 1:N (as sender), 1:N (as recipient)
