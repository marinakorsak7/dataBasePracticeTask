INSERT INTO film (title, rental_rate, rental_duration, language_id)
VALUES ('3 Body Problem', 4.99, 14, 1);



INSERT INTO actor (first_name, last_name)
VALUES 
    ('Eiza', 'González'),
    ('Jess', 'Hong'),
    ('John', 'Bradley');

WITH NewActors AS (
    SELECT actor_id, first_name, last_name
    FROM actor
    WHERE first_name IN ('Eiza', 'Jess', 'John')
)
INSERT INTO film_actor (actor_id, film_id)
SELECT actor_id, (SELECT film_id FROM film WHERE title = '3 Body Problem')
FROM NewActors;



SELECT film_id FROM film
WHERE title LIKE '3 Body Problem'; -- 1002

INSERT INTO inventory (film_id, store_id)
VALUES (1002, 1);
