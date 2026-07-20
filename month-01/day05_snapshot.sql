--Q1. All PG-13 films longer than two hours - title and length, longest first.

SELECT title, length
FROM film
WHERE rating = 'PG-13' AND length > 120
ORDER BY length DESC;

--Q2. The different rental_duration values that exist, smallest first.

SELECT DISTINCT rental_duration
FROM film
ORDER BY rental_duration;

--Q3. For each rating: how many films and the average rental rate (2 decimals). Most films first.

SELECT rating, COUNT(*) AS film_count,
        ROUND(AVG(rental_rate), 2) AS avg_len
FROM film
GROUP BY rating
ORDER BY film_count DESC;

--Q4. Which ratings have an average length over 115 minutes?

SELECT rating, ROUND(AVG(rental_rate), 1) AS avg_len
FROM film
GROUP BY rating
HAVING AVG(length) > 115;

--Q5. One row per rating: films under 100 minutes, films 100+ minutes, and a total.

SELECT rating,
        COUNT(CASE WHEN length < 100 THEN 1 END) AS under_100,
        COUNT(CASE WHEN length >= 100 THEN 1 END) AS at_least_100,
        COUNT(*) AS total
FROM film
GROUP BY rating
ORDER BY rating;