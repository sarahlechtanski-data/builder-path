-- G1. Every film stamped with a runtime tier

SELECT
    title,
    length,
    CASE
        WHEN length < 90 THEN 'short'
        WHEN length <= 150 THEN 'standard'
        ELSE 'epic'
    END AS runtime_tier
FROM film
LIMIT 15;

-- G2. The order matters thought experiment.

SELECT
    title,
    length,
    CASE
        WHEN length <= 150 THEN 'standard'
        WHEN length < 90 THEN 'short'
        ELSE 'epic'
    END AS runtime_tier
FROM film
LIMIT 15;

-- G3. Price tiers (no ELSE - deliberately)

SELECT
    title,
    rental_rate,
    CASE
        WHEN rental_rate = 0.99 THEN 'budget'
        WHEN rental_rate = 2.99 THEN 'standard'
        WHEN rental_rate = 4.99 THEN 'premium'
    END AS price_tier
FROM film
LIMIT 15;

-- G4. Deliberately incomplete - what do 2.99 and 4.99 films get stamped with?

SELECT
    title,
    rental_rate,
    CASE
        WHEN rental_rate = 0.99 THEN 'budget'
    END AS incomplete_tier
FROM film
LIMIT 15;

-- G5. Professional version: the loud ELSE

SELECT
    title,
    rental_rate,
    CASE
        WHEN rental_rate = 0.99 THEN 'budget'
        WHEN rental_rate = 2.99 THEN 'standard'
        WHEN rental_rate = 4.99 THEN 'premium'
        ELSE 'UNEXPECTED - investigate'
    END AS price_tier
FROM film
LIMIT 15;

-- G6. Sort ratings in MPAA severity order (alphabetical would be wrong: G, NC-17, PG...)

SELECT
    title, rating FROM film
ORDER BY    
    CASE rating
        WHEN 'G' THEN 1
        WHEN 'PG' THEN 2
        WHEN 'PG-13' THEN 3
        WHEN 'R' THEN 4
        WHEN 'NC-17' THEN 5
    END
LIMIT 20;

-- G7. Films per invented runtime tier

SELECT  
    CASE
        WHEN length < 90 THEN 'short'
        WHEN length >=150 THEN 'standard'
        ELSE 'epic'
    END AS runtime_tier,
    COUNT(*) AS film_count
FROM film
GROUP BY runtime_tier
ORDER BY film_count DESC;

-- G8. The analyst table, on buckets you invented

SELECT
    CASE
        WHEN length < 90 THEN 'short'
        WHEN length >=150 THEN 'standard'
        ELSE 'epic'
    END AS runtime_tier,
    COUNT(*) AS film_count,
    ROUND(AVG(rental_rate), 2) AS avg_price,
    ROUND(AVG(replacement_cost), 2) AS avg_replacement
FROM film
GROUP BY runtime_tier
ORDER BY film_count DESC;

-- G9. Which invented tiers average a rental rate above 2.90?

SELECT
    CASE
        WHEN length < 90 THEN 'short'
        WHEN length >= 150 THEN 'standard'
        ELSE 'epic'
    END AS runtime_tier,
    ROUND(AVG(rental_rate), 2) AS avg_price
FROM film
GROUP BY runtime_tier
HAVING AVG(rental_rate) > 2.90;

-- G10. Rating x invented tier: fifteen buckets

SELECT
    rating,
    CASE 
        WHEN length < 90 THEN 'short'
        WHEN length >= 150 THEN 'standard'
        ELSE 'epic'
    END AS runtime_tier,
    COUNT(*) AS film_count
FROM film
GROUP BY rating, runtime_tier
ORDER BY rating, runtime_tier;

-- G11. One row per rating; tiers spread across COLUMNS

SELECT
    rating,
    COUNT(CASE WHEN length < 90 THEN 1 END) AS short_films,
    COUNT(CASE WHEN length BETWEEN 90 AND 150 THEN 1 END) AS standard_films,
    COUNT(CASE WHEN length > 150 THEN 1 END) AS epic_films,
    COUNT(*) AS total
FROM film
GROUP BY rating
ORDER BY rating;

-- G13. Revenue-weighted view: premium vs budget dollars per rating

SELECT
    rating,
    ROUND(SUM(CASE WHEN rental_rate = 4.99 THEN rental_rate END), 2) AS premium_revenue,
    ROUND(SUM(CASE WHEN rental_rate = 0.99 THEN rental_rate END), 2) AS budget_revenue
FROM film
GROUP BY rating
ORDER BY rating;

-- S1. Label each film 'cheap' (under 2.00) or 'pricey' (2.00 and up): title, rental_rate, and the label. First 15 rows.
--Boundary check before running: where does a hypothetical 2.00 film land?

SELECT
    title,
    rental_rate,
    CASE
        WHEN rental_rate < 2.00  THEN 'cheap'
        WHEN rental_rate >= 2.00 THEN 'pricey'
        ELSE 'UNEXPECTED - investigate'
    END AS price_tier
FROM film
LIMIT 15;

-- S2. How many films wear each of the two price labels?

SELECT
    CASE
        WHEN rental_rate < 2.00  THEN 'cheap'
        WHEN rental_rate >= 2.00 THEN 'pricey'
    END AS price_tier,
    COUNT(*) AS film_count
FROM film
GROUP BY price_tier
ORDER BY film_count DESC;

-- S3. Average replacement_cost per S1 label. 2 decimals, aliased properly.

SELECT
    CASE
        WHEN rental_rate < 2.00  THEN 'cheap'
        WHEN rental_rate >= 2.00 THEN 'pricey'
    END AS price_tier,
    COUNT(*) AS film_count,
    ROUND(AVG(replacement_cost), 2) AS avg_replacement
FROM film
GROUP BY price_tier
ORDER BY film_count;

-- S4. Invent three replacement_cost tiers - 'low' (under 15), 'mid' (15 up to 25), 'high' (25 and up) - and count films in each.

SELECT
    CASE
        WHEN replacement_cost < 15.00 THEN 'low'
        WHEN replacement_cost < 25.00 THEN 'mid'
        ELSE 'high'
    END AS cost_tier,
    COUNT(*) AS film_count
FROM film
GROUP BY cost_tier
ORDER BY film_count DESC;

-- S5. A pivot: one row per rental_rate, columns counting G, PG, and R films at that price.

SELECT
    rental_rate,
    COUNT(CASE WHEN rating = 'G'  THEN 1 END) AS g_films,
    COUNT(CASE WHEN rating = 'PG' THEN 1 END) AS pg_films,
    COUNT(CASE WHEN rating = 'R'  THEN 1 END) AS r_films
FROM film
GROUP BY rental_rate
ORDER BY rental_rate;

-- S6. Which of your S4 cost tiers average a runtime over 110 minutes?

SELECT
    CASE
        WHEN replacement_cost < 15.00 THEN 'low'
        WHEN replacement_cost < 25.00 THEN 'mid'
        ELSE 'high'
    END AS cost_tier,
    ROUND(AVG(length), 1) AS avg_runtime
FROM film
GROUP BY cost_tier
HAVING AVG(length) > 110;

-- S7. One row per rating; columns counting budget/standard/premium films + total,
-- ordered by total descending.

SELECT
    rating,
    COUNT(CASE WHEN rental_rate = 0.99 THEN 1 END) AS budget_films,
    COUNT(CASE WHEN rental_rate = 2.99 THEN 1 END) AS standard_films,
    COUNT(CASE WHEN rental_rate = 4.99 THEN 1 END) AS premium_films,
    COUNT(*) AS total
FROM film
GROUP BY rating
ORDER BY total DESC;