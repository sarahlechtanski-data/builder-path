--EXAMPLE (Films longer than the average film)

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) from film)
ORDER BY length DESC
LIMIT 5;

--2.1 Films with a rental_rate above the average rental_rate - title and rate, priciest first, top 10.

SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) from film)
ORDER BY rental_rate DESC
LIMIT 10;

--2.2 Films SHORTER than the average length - just count how many there are.

SELECT COUNT(*) AS shortest_than_average
FROM film
WHERE length < (SELECT AVG(length) from film);