-- Creating the view "sales_revenue_by_category_qtr"
CREATE VIEW sales_revenue_by_category_qtr AS
SELECT
    c.name AS category,
    SUM(p.amount) AS total_sales_revenue
FROM
    film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
JOIN category c ON fc.category_id = c.category_id
WHERE
    EXTRACT(QUARTER FROM p.payment_date) = EXTRACT(QUARTER FROM CURRENT_DATE)
GROUP BY
    c.name
HAVING
    SUM(p.amount) > 0;

-- Creating the query language function "get_sales_revenue_by_category_qtr"
CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(current_quarter integer)
RETURNS TABLE (category text, total_sales_revenue numeric)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.name AS category,
        SUM(p.amount) AS total_sales_revenue
    FROM
        film_category fc
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE
        EXTRACT(QUARTER FROM p.payment_date) = current_quarter
    GROUP BY
        c.name
    HAVING
        SUM(p.amount) > 0;
END;
$$ LANGUAGE plpgsql;

-- Creating the procedure language function "new_movie"
CREATE OR REPLACE FUNCTION new_movie(movie_title text)
RETURNS void
AS $$
DECLARE
    lang_id integer;
BEGIN
    -- Check if the language exists
    SELECT language_id INTO lang_id
    FROM language
    WHERE name = 'Klingon';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Language "Klingon" does not exist.';
    END IF;

    -- Insert new movie
    INSERT INTO film (title, rental_rate, rental_duration, replacement_cost, release_year, language_id)
    VALUES (movie_title, 4.99, 3, 19.99, EXTRACT(YEAR FROM current_date)::integer, lang_id);
END;
$$ LANGUAGE plpgsql;
