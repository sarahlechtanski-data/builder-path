-- G1. What distinct ratings does Pagila use?
SELECT DISTINCT rating FROM film;

-- G2. Same, alphabetized (cleaner habit)
SELECT DISTINCT rating FROM film
ORDER BY rating;

-- G3. DISTINCT applies to the COMBINATION of listed columns:
-- every unique (rating, rental_duration) pair that occurs
SELECT DISTINCT rating, rental_duration FROM film
ORDER BY rating, rental_duration;

-- G4. Self-explanatory output names
SELECT title, length AS runtime_minutes FROM film
ORDER BY runtime_minutes DESC
LIMIT 10;

-- G5. Mutiple aliases; note the formatting style when list grows
SELECT  
    title AS film_title,
    rental_rate AS price_usd,
    length AS runtime_minutes
FROM film
LIMIT 5;

-- G6. A one-week preview: COUNT + GROUP BY (Week 2's core topic).
-- Just notice how much clearer the aliased output reads.
SELECT rating AS mpaa_rating, COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC;

-- G7. The correct way to find the missing values
SELECT title, original_language_id FROM film
WHERE original_language_id IS NULL
LIMIT 5;

-- G8. THE CLASSIC BUG - identical intent, returns ZERO rows, no error, no warning
SELECT title FROM film
WHERE original_language_id = NULL;

-- G9. The correct way to find the present values
SELECT title, description FROM film
WHERE description is NOT NULL
LIMIT 5;

-- S1 Every distinct rental_duration value that occurs in the film table, smallest first. 
--How many different loan periods does the business offer?
SELECT rental_duration, COUNT(*) AS film_count FROM film
GROUP BY rental_duration
ORDER BY rental_duration ASC;

-- S2 The five most expensive films by rental_rate, showing title and rental_rate aliased as price_usd. 
--(ORDER BY + LIMIT + AS.)
SELECT  
    title AS film_title,
    rental_rate AS price_usd
FROM film
ORDER BY price_usd DESC
LIMIT 5;

-- S3 Films where original_language_id is missing, but this time show title and rating, ordered by title, first 10 only.
--(The correct NULL idiom + ORDER BY + LIMIT.)
SELECT title, rating FROM film
WHERE original_language_id IS NULL
ORDER BY title
LIMIT 10;

-- S4 The distinct ratings that appear among films longer than 3 hours. 
--(DISTINCT + WHERE on a different column.)
SELECT DISTINCT rating FROM film
WHERE length > 180;

-- S5 Films rated G or PG with a rental rate under 1.00, title aliased as family_bargain, alphabetized.
--(IN + AND + AS.)
SELECT 
    title AS family_bargain,
    rating,
    rental_rate
FROM film
WHERE rating IN ('G', 'PG') AND rental_rate < 1.00
ORDER BY title ASC;
