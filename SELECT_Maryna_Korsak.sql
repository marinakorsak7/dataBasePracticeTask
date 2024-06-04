SELECT MAX(store_revenue) AS max_revenue
FROM (
    SELECT i.store_id, SUM(p.amount) AS store_revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE p.payment_date BETWEEN '2017-01-01' AND '2017-12-31'
    GROUP BY i.store_id
) AS revenue_by_store;

WITH StaffRevenue AS (
    SELECT
        s.store_id,
        s.staff_id,
        s.first_name,
        s.last_name,
        SUM(p.amount) AS total_revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN staff s ON p.staff_id = s.staff_id
    WHERE p.payment_date BETWEEN '2017-01-01' AND '2017-12-31'
    GROUP BY s.store_id, s.staff_id, s.first_name, s.last_name
),
MaxStoreRevenue AS (
    SELECT
        store_id,
        MAX(total_revenue) AS max_revenue
    FROM StaffRevenue
    GROUP BY store_id
)
SELECT
    sr.store_id,
    sr.staff_id,
    sr.first_name,
    sr.last_name,
    sr.total_revenue
FROM StaffRevenue sr
JOIN MaxStoreRevenue msr ON sr.store_id = msr.store_id AND sr.total_revenue = msr.max_revenue
ORDER BY sr.store_id;


WITH MovieRentals AS (
    SELECT
        f.film_id,
        f.title,
        f.rating,
        COUNT(r.rental_id) AS rental_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title, f.rating
),
TopMovies AS (
    SELECT
        film_id,
        title,
        rating,
        rental_count,
        ROW_NUMBER() OVER (ORDER BY rental_count DESC) AS rank
    FROM MovieRentals
)
SELECT
    tm.film_id,
    tm.title,
    tm.rating,
    tm.rental_count
FROM TopMovies tm
WHERE tm.rank <= 5
ORDER BY tm.rank;