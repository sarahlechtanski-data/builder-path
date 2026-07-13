SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

--Every film and it's release year
SELECT title, rating FROM film
WHERE rating = 'R';

--Films longer than two hours, longest first
SELECT title FROM film
WHERE length > 120
ORDER BY length DESC;

--The ten cheapest rentals (ties broken alphabetically)
SELECT title, rental_rate FROM film
ORDER BY rental_rate ASC, title ASC
LIMIT 10;

--AND: family-friendly epics
SELECT title, rating, length FROM film
WHERE length >= 150 AND rating IN ('PG','PG-13')
ORDER BY length DESC;

--Pattern matching: Titles starting with T
SELECT title FROM film
WHERE title LIKE 'T%'
ORDER BY title;

--Ranges: mid-length films via BETWEEN
SELECT title, length FROM film
WHERE length BETWEEN 90 AND 100
ORDER BY length, title;

--NOT and <>: Everything except G-rated
SELECT title, rating FROM film
WHERE rating <> 'G'
ORDER BY title
LIMIT 20;

--All films with a rental rate of exactly 4.99, alphabetized
SELECT title, rental_rate FROM film
WHERE rental_rate = 4.99
ORDER BY title ASC;

--The five shortest films -- title and length only
SELECT title, length FROM film
ORDER BY length ASC
LIMIT 5;

--PG films longer than 180 minutes. (How many are there? 39 Count the rows returned)
SELECT title, length FROM film
WHERE length > 180
ORDER BY title, length;

--Films whose title ends in the word LIFE. Hint: LIKE '%LIFE'
SELECT title FROM film
WHERE title LIKE '%LIFE'
ORDER BY title;

--Films with a replacement_cost over 25.00, most expensive first, top 10
SELECT title, replacement_cost FROM film
WHERE replacement_cost > 25.00
ORDER BY title DESC
LIMIT 10;

--Films rated either G or PG that are shorter than 60 minutes. Combine IN with AND
SELECT title, rating, length FROM film
WHERE rating IN ('G', 'PG')
AND length < 60
ORDER BY title;