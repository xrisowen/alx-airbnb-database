### Normalize Your Database Design

#### Let’s check your entities one by one:

##### User
user_id is the PK.
Attributes: first_name, last_name, email, password_hash, phone_number, role, created_at.
All depend directly on user_id.
In 3NF.

##### Property
property_id is the PK.
host_id is FK → User(user_id).
All attributes (name, description, location, pricepernight, created_at, updated_at) depend only on property_id.
No transitive dependencies.
In 3NF.

##### Booking
booking_id is PK.
FKs: property_id, user_id.
Attributes (start_date, end_date, total_price, status, created_at) depend only on booking_id.
No derived/transitive attributes stored (e.g., total_price could be argued as derived from end_date - start_date * pricepernight, but it’s fine to keep for performance — denormalization choice).
Still acceptable in 3NF.

##### Payment
payment_id is PK.
FK: booking_id.
Attributes (amount, payment_date, payment_method) depend only on payment_id.
In 3NF.

##### Review
review_id is PK.
FKs: property_id, user_id.
Attributes (rating, comment, created_at) depend only on review_id.
In 3NF.

##### Message
message_id is PK.
FKs: sender_id, recipient_id.
Attributes (message_body, sent_at) depend only on message_id.
In 3NF.
