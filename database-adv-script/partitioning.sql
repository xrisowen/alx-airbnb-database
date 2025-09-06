--=====================Partition table with data===================

-- 1. Backup existing bookings table (safety)
CREATE TABLE IF NOT EXISTS bookings_backup AS TABLE bookings;

-- 2. Rename current bookings table
ALTER TABLE bookings RENAME TO bookings_old;

-- 3. Create new partitioned parent table
CREATE TABLE bookings (
    booking_id UUID,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	-- The PRIMARY KEY now includes both booking_id and start_date to satisfy
    -- the partitioning constraint.
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- 4. Create partitions (yearly example)
CREATE TABLE bookings_2024 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Add more partitions as needed

-- 5. Move data from old table into partitioned table
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
SELECT booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at
FROM bookings_old;  

-- 6. Drop old table (only after confirming data migrated successfully)
-- DROP TABLE bookings_old;

-- 7. Add indexes to partitions (indexes are not inherited)
--But PostgreSQL 11+ has a convenience feature
CREATE INDEX idx_bookings_user_id ON bookings (user_id) INCLUDE (start_date);
CREATE INDEX idx_bookings_property_id ON bookings (property_id) INCLUDE (start_date);
--CREATE INDEX idx_bookings_user_id ON bookings (user_id) INCLUDE (start_date, property_id) ON ALL PARTITIONS;

--CREATE INDEX idx_bookings_2024_user_id ON bookings_2024(user_id);
--CREATE INDEX idx_bookings_2025_user_id ON bookings_2025(user_id);
--CREATE INDEX idx_bookings_property_id ON bookings (property_id);
--CREATE INDEX idx_bookings_user_id ON bookings (user_id);
--CREATE INDEX idx_bookings_start_date ON bookings (start_date);

-- Done 🚀

-- Example query to test performance improvement
EXPLAIN ANALYZE
SELECT * 
FROM bookings
WHERE start_date BETWEEN '2024-03-01' AND '2024-03-31';
