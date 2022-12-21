/* 
Q1: Create a query that lists 10 movies, the film category it is classified in, and the number of times it has been rented out.
*/



SELECT
f.title AS film_title, c.name AS category_name, COUNT(r.rental_id) AS rental_count
FROM 
film_category fc
JOIN category c
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r 
ON r.inventory_id = i.inventory_id
WHERE
c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 
f.title, C.name
LIMIT 10;




/* Q2: Find the information of most 10 paid customer? */ 

SELECT customer_id,
       customer_name,
       sum(sum)
FROM(SELECT cu.customer_id AS "customer_id",
     	      p.payment_id"payment_id",
            cu.first_name || ' ' || cu.last_name AS "customer_name",
            SUM(p.amount) OVER (PARTITION BY cu.customer_id ORDER BY p.payment_id)
     FROM customer cu
     JOIN payment p
     ON p.customer_id = cu.customer_id)sub
GROUP BY customer_id,customer_name
ORDER BY sum DESC
LIMIT 10;




/* Q3: Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.*/ 


 SELECT DATE_PART('month',rnt.rental_date) rental_month, 
       DATE_PART('year',rnt.rental_date) rental_year, 
       s.store_id,
       COUNT(rnt.rental_id) rental_count
FROM rental AS rnt
JOIN staff AS st ON rnt.staff_id = st.staff_id
JOIN store AS s ON s.store_id = st.store_id
GROUP BY 1,2,3
ORDER BY 4 ASC;




/* Q4: provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. 
*/

SELECT
t1.name, t1.standard_quartile, COUNT(t1.standard_quartile)
FROM
(SELECT f.title, c.name , f.rental_duration, NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM 
film_category fc
JOIN category c
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
WHERE
c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) t1 
GROUP BY 1, 2;