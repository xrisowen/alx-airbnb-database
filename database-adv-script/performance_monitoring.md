# DB Performance Monitoring and Refinement

## 1. Monitoring Queries

We used the `EXPLAIN ANALYZE` and `SHOW PROFILE` commands on some of the most frequently executed queries in the system.  
Examples include:

```sql
-- Example 1: Fetch bookings with user and property details
EXPLAIN ANALYZE
SELECT 
    b.booking_id, b.start_date, b.end_date,
    u.first_name,
    p.name AS property_name
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date >= '2025-01-01' 
ORDER BY b.start_date DESC;

-- Example 2: Fetch payments by booking ID
EXPLAIN ANALYZE
SELECT * 
FROM payments
WHERE booking_id = 123;
```

### Observed Issues:
Queries against the bookings table were performing slowly, especially when filtering by start_date, because they were doing full table scans. Similarly, 
JOINs between the bookings, users, and properties tables were inefficient as the amount of data grew. In addition, the payments query was slow due to a 
missing index on the booking_id column, which resulted in the database having to scan the entire table to find the matching records.

## 2. Suggested Changes
1. **Schema Adjustments**
    - Considered partitioning the `bookings` table by `start_date` (already implemented in `partitioning.sql`).
    - Ensured that frequently joined columns (`user_id`, `property_id`, `booking_id`) are indexed.

2. **Query Refinements**
    - Restricted queries to only necessary columns instead of `SELECT *`.
    - Replaced subqueries with joins where beneficial.

## Results
- **Query Execution Time:**
    - The `bookings` query with `start_date` filter reduced after indexing and partitioning.
    - The `payments` query lookup improved adding an index on `booking_id`.

- **Joins Performance:**
    - The join between `bookings`, `users`, and `properties` showed improved query plans with index usage.
    - Reduced full table scans, improving performance on larger datasets
