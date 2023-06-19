GRANT ALL PRIVILEGES ON DATABASE dvdrental TO postgres;

SELECT * FROM category;
SELECT * FROM inventory;
SELECT * FROM customer;
SELECT * FROM film_category;
SELECT * FROM rental;
SELECT * FROM film;
SELECT * FROM payment;
SELECT * FROM address;
SELECT * FROM language;
SELECT * FROM staff;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM store;
SELECT * FROM actor;
SELECT * FROM film_actor;

--Aquellas usadas para insertar, modificar y eliminar un Customer, 
--Staff y Actor.
INSERT INTO 
customer(customer_id, store_id, first_name, last_name, email,address_id, activebool, create_date, last_update,active)
VALUES(?,?,?,?,?,?,?,?,?,?);
UPDATE customer SET column_name = 'nuevo_valor' WHERE customer_id = 1;
DELETE FROM customer WHERE customer_id = 1;

INSERT INTO 
staff(staff_id, first_name, last_name,address_id,email,store_id,active,username,password,last_update,picture)
VALUES(?,?,?,?,?,?,?,?,?,?,?);
UPDATE staff SET column_name = 'nuevo_valor' WHERE staff_id = 1;
DELETE FROM staff WHERE staff_id = 1;

INSERT INTO 
actor(actor_id, first_name, last_name,last_update)
VALUES(?,?,?,?);
UPDATE actor SET column_name = 'nuevo_valor' WHERE actor_id = 1;
DELETE FROM actor WHERE actor_id = 1;

--Listar todas las “rental” con los datos del “customer” dado un año y mes.
SELECT r.*, c.* FROM rental as r --datos que se desean obtener y de donde
JOIN customer as c --union con la tabla y alias
ON r.customer_id = c.customer_id --parametro o dato para la únion PK, FK
WHERE EXTRACT(YEAR FROM r.rental_date) = '2005'
AND
EXTRACT(MONTH FROM r.rental_date) = '06';

SELECT rental.*, customer.* FROM rental --datos que se desean obtener y de donde
JOIN customer --union con la tabla y alias
ON rental.customer_id = customer.customer_id --parametro o dato para la únion PK, FK
WHERE EXTRACT(YEAR FROM rental.rental_date) = '2005'
AND
EXTRACT(MONTH FROM rental.rental_date) = '05';

SELECT r.*, c.* FROM rental as r
JOIN customer as c
ON r.customer_id = c.customer_id
WHERE r.rental_date BETWEEN '2005-05-01' AND '2005-05-31';

--Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”.
SELECT payment_id as numero_payment,payment_date as fecha,amount as total
FROM payment
ORDER BY fecha asc;
				  
SELECT CAST (payment_date as DATE) FROM payment;
SELECT payment_date::DATE FROM payment;
SELECT payment_date::TIME FROM payment;

--Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.
SELECT * FROM film
    WHERE release_year = 2006 AND rental_rate > 4;

--Diccionario de datos, ver la constitucion de la base de datos y documentación
SELECT t1.TABLE_NAME AS tabla_nombre,
		t1.COLUMN_NAME AS columna_nombre,
		t1.COLUMN_DEFAULT AS columna_defecto,
		t1.IS_NULLABLE AS columna_nulo,
		t1.DATA_TYPE AS columna_tipo_dato,
		COALESCE(t1.NUMERIC_PRECISION,t1.CHARACTER_MAXIMUM_LENGTH) AS columna_longitud,
		PG_CATALOG.COL_DESCRIPTION(
			t2.OID,
			t1.DTD_IDENTIFIER::int) AS columna_descripcion, 
			t1.DOMAIN_NAME AS columna_dominio FROM INFORMATION_SCHEMA.COLUMNS t1 
			INNER JOIN PG_CLASS t2
			ON(t2.RELNAME=t1.TABLE_NAME)
			WHERE t1.TABLE_SCHEMA ='public' ORDER BY 
			t1.TABLE_NAME;
			
SELECT 
table_name AS nombre_tabla, 
column_name AS nombre_columna, 
is_nullable AS columna_nulo, 
data_type AS tipo_dato
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name ASC;			
