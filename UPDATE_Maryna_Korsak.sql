UPDATE film
SET rental_duration = 21, 
    rental_rate = 9.99
WHERE title = 'Interstellar';


UPDATE customer
SET first_name = 'Maryna',
    last_name = 'Korsak',
    email = 'korsak.maryna@student.ehu.lt',
    address_id = 1 
WHERE customer_id = 1;


UPDATE customer
SET create_date = CURRENT_DATE
WHERE customer_id = 1;
