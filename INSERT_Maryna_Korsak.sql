INSERT INTO film (title, rental_rate, rental_duration, language_id)
VALUES ('Interstellar', 4.99, 14, 1);



INSERT INTO actor (first_name, last_name)
VALUES 
    ('Matthew', 'McConaughey'),
    ('Jessica', 'Chastain'),
    ('Anne', 'Hathaway');

WITH NewActors AS (
    SELECT actor_id, first_name, last_name
    FROM actor
    WHERE first_name IN ('Matthew', 'Jessica', 'Anne')
)
INSERT INTO film_actor (actor_id, film_id)
SELECT actor_id, (SELECT film_id FROM film WHERE title = 'Interstellar')
FROM NewActors;



SELECT film_id FROM film
WHERE title LIKE 'Interstellar'; -- 1002

INSERT INTO inventory (film_id, store_id)
VALUES (1002, 1);
