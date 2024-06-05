SELECT film_id
FROM film
WHERE title = 'Interstellar';

DELETE FROM rental
WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE film_id = 1002
);

DELETE FROM inventory
WHERE film_id = 1002;

SELECT customer_id
FROM customer
WHERE first_name = 'Maryna' AND last_name = 'Korsak';

DELETE FROM payment
WHERE customer_id = 1;

DELETE FROM rental
WHERE customer_id = 1;

