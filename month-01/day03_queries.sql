-- G1. How many films are in the catalog?

SELECT COUNT(*) AS film_count FROM film;

-- G2. What's the average rental rate across the whole catalog?

SELECT AVG(rental_rate) AS avg_price FROM film;

-- G3. Shortest and longest runtimes, side by side.
-- (multiple aggregates can share one query)

SELECT
    MIN(length) AS shortest_minutes,
    MAX(length) AS longest_minutes
FROM film;

-- G4. Same average, human-readable: ROUND(value, decimal_places)

SELECT ROUND(AVG(rental_rate), 2) AS avg_price FROM film;

-- G5. If one copy of every film rented once, total revenue?

SELECT SUM(rental_rate) AS catalog_revenue FROM film;

-- G6. COUNT(*) counts ROWS. COUNT(column) counts NON-NULL values in it.

SELECT
    COUNT(*) AS all_rows,
    COUNT(original_language_id) AS rows_with_a_value
FROM film;

-- G7. Average rental rate PER RATING -- the 'per' question answered

SELECT rating, ROUND(AVG(rental_rate), 2) AS avg_price
FROM film
GROUP BY rating
ORDER BY avg_price DESC;

-- G8. How many films in each bucket?

SELECT rating, COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC;

-- G9. Several aggregates per bucket at once -- this is a real analyst table

SELECT
    rating,
    COUNT(*) AS film_count,
    ROUND(AVG(length), 1) AS avg_runtime,
    MIN(length) AS shortest,
    MAX(length) AS longest
FROM film
GROUP BY rating
ORDER BY rating;

-- G10. INTENTIONALLY BROKEN -- run it and read the error

SELECT rating, title, COUNT(*)
FROM film
GROUP BY rating;

-- G11. Grouping by TWO columns: buckets become (rating, rental_rate) pairs

SELECT rating, rental_rate, COUNT(*) AS film_count
FROM film
GROUP BY rating, rental_rate
ORDER BY rating, rental_rate;

-- G12. First, feel the problem -- this FAILS (run it, read it):

SELECT rating, COUNT(*) AS film_count
FROM film
WHERE COUNT(*) > 200
GROUP BY rating;

-- G13. The fix -- HAVING filters groups AFTER aggregation:

SELECT rating, COUNT(*) AS film_count
FROM film
GROUP BY rating
HAVING COUNT(*) > 200
ORDER BY film_count DESC;

-- G14. WHERE and HAVING together, each doing its own job:

SELECT rating, COUNT(*) AS long_film_count
FROM film
WHERE length > 120
GROUP BY rating
HAVING COUNT(*) > 40
ORDER BY long_film_count DESC;

-- S1. How many films are in each rental_rate tier?

SELECT rental_rate, COUNT(*) AS film_count
FROM film
GROUP BY rental_rate
ORDER BY rental_rate;

-- S2. The average runtime per rating, rounded to 1 decimal, longest-average first.

SELECT
    rating,
    ROUND(AVG(length), 1) AS avg_runtime
FROM film
GROUP BY rating
ORDER BY avg_runtime DESC;

-- S3. Total replacement_cost of the whole catalog (one number -- what would it cost to replace every film?).

SELECT ROUND(SUM(replacement_cost), 2) AS total_replacement_cost
FROM film;

-- S4. The longest film within each rental_rate tier. (MAX per bucket.)

SELECT rental_rate, MAX (length) AS longest_film_length
FROM film
GROUP BY rental_rate;

-- S5. Which ratings have an average rental rate above 2.90?

SELECT
    rating,
    ROUND(AVG(rental_rate), 2) AS avg_price
FROM film
GROUP BY rating
HAVING AVG(rental_rate) > 2.90;

-- S6. Among films two hours or longer, how many does each rating have -- but only show ratings with more than 30 such films.

SELECT rating, COUNT(*) AS rating_count
FROM film
WHERE length >= 120
GROUP BY rating
HAVING COUNT(*) > 30
ORDER BY rating_count DESC;

-- S7. For each rating: film count, average price, average runtime, priciest replacement cost.

SELECT
    rating,
    COUNT(*)                        AS film_count,
    ROUND(AVG(rental_rate), 2)      AS avg_price,
    ROUND(AVG(length), 1)           AS avg_runtime,
    MAX(replacement_cost)           AS priciest_replacement
FROM film
GROUP BY rating
ORDER BY film_count DESC;
