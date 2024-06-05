UPDATE film
SET rental_duration = 21, 
    rental_rate = 9.99
WHERE title = '3 Body Problem';


UPDATE customer
SET first_name = 'Rahneda',
    last_name = 'Charnysh',
    email = 'charnysh.rahneda@student.ehu.lt',
    address_id = 1 
WHERE customer_id = 1;


UPDATE customer
SET create_date = CURRENT_DATE
WHERE customer_id = 1;
