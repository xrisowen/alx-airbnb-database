#### Notes:

1. gen_random_uuid() generates unique UUIDs (requires pgcrypto extension).
2. Data includes 1 guest (Alice), 2 hosts (Bob & Clara), 1 admin (David).
3. Bookings, payments, reviews, and messages link correctly via FKs.
4. You can run these scripts in sequence after creating the schema.


The function gen_random_uuid() in PostgreSQL (provided by the pgcrypto extension) generates a UUID v4, which is a random-based UUID.

🔎 Key facts about gen_random_uuid():
UUID v4 uses 122 random bits (out of 128 total bits, with 6 reserved for version/variant).
This means there are about 5.3 × 10³⁶ possible unique values.
The probability of a collision (two identical UUIDs being generated) is astronomically low.

👉 To put it in perspective:
If you generate 1 billion UUIDs per second for 100 years, the chance of a collision is still close to zero (far less than winning the lottery multiple times in a row).

✅
No, gen_random_uuid() will almost certainly not generate the same number in the near future.
For all practical database applications, UUID collisions are considered impossible.
