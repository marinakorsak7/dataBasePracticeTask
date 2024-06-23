-- Create a new user with the username "rentaluser" and the password "rentalpassword"
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';

-- Grant "rentaluser" SELECT permission for the "customer" table. Check to make sure this permission works correctly
GRANT CONNECT ON DATABASE dvd_rental TO rentaluser;
GRANT SELECT ON TABLE customer TO rentaluser;

SELECT * FROM customer;

-- Create a new user group called "rental" and add "rentaluser" to the group
CREATE ROLE rental;
GRANT rental TO rentaluser;

-- Grant the "rental" group INSERT and UPDATE permissions for the "rental" table. Insert a new row and update one existing row in the "rental" table under that role
GRANT INSERT, UPDATE ON TABLE rental TO rental;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id) 
VALUES ('2024-05-05', 1, 1, '2024-05-20', 1);

UPDATE rental
SET return_date = '2024-05-25'
WHERE rental_id = 1;

-- Revoke the "rental" group's INSERT permission for the "rental" table. Try to insert new rows into the "rental" table and make sure this action is denied
REVOKE INSERT ON TABLE rental FROM rental;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id) 
VALUES ('2024-02-01', 2, 2, '2024-02-10', 2);

-- Create a personalized role for any customer already existing in the dvd_rental database
DO
$$
DECLARE
    customer RECORD;
BEGIN
    SELECT first_name, last_name INTO customer 
    FROM customer 
    WHERE customer_id = 12;

    EXECUTE format('CREATE ROLE client_%s_%s LOGIN', customer.first_name, customer.last_name);

    EXECUTE format('GRANT CONNECT ON DATABASE dvd_rental TO client_%s_%s', customer.first_name, customer.last_name);

    EXECUTE format('GRANT SELECT ON TABLE rental TO client_%s_%s', customer.first_name, customer.last_name);
    EXECUTE format('GRANT SELECT ON TABLE payment TO client_%s_%s', customer.first_name, customer.last_name);

    EXECUTE format('CREATE POLICY rental_policy ON rental FOR SELECT TO client_%s_%s USING (customer_id = 12)', customer.first_name, customer.last_name);
    EXECUTE format('CREATE POLICY payment_policy ON payment FOR SELECT TO client_%s_%s USING (customer_id = 12)', customer.first_name, customer.last_name);

    EXECUTE format('ALTER TABLE rental ENABLE ROW LEVEL SECURITY');
    EXECUTE format('ALTER TABLE payment ENABLE ROW LEVEL SECURITY');
END
$$;

SELECT * FROM rental WHERE customer_id = 12;
SELECT * FROM payment WHERE customer_id = 12;
