CREATE TABLE empresa (
	rut VARCHAR(10)PRIMARY KEY,
	nombre VARCHAR(120),
	direccion VARCHAR(120),
	telefono VARCHAR(15),
	correo VARCHAR(80),
	web VARCHAR(50)
);

CREATE TABLE cliente (
	rut VARCHAR(10) PRIMARY KEY,
	nombre VARCHAR(120),
	correo VARCHAR(80),
	direccion VARCHAR(120),
	celular VARCHAR(15)
);

CREATE TABLE herramienta (
	herramienta_id INT PRIMARY KEY,
	nombre VARCHAR(120),
	precio_dia MONEY
);

CREATE TABLE arriendo (
	folio INT PRIMARY KEY,
	fecha DATE,
	dias INT,
	valor_dia INT,
	garantia VARCHAR(30),
	herramienta_id INT,
	rut_cliente VARCHAR(10)
);

ALTER TABLE arriendo 
ADD CONSTRAINT fk_herramienta_id 
FOREIGN KEY(herramienta_id) 
REFERENCES herramienta(herramienta_id);


ALTER TABLE arriendo 
ADD CONSTRAINT fk_rut_cliente 
FOREIGN KEY(rut_cliente) 
REFERENCES cliente(rut);

INSERT into empresa VALUES('11111111-1','Arrienda Herramientas','0123 Avenida Real',1234567890,'datosarriendo@herramientas.es','arrimientas.es');

INSERT into herramienta VALUES(1,'Taladro Electrico',10000),
                              (2,'Cierra Electrica',20000),
                              (3,'Pistola de Clavos',30000),
                              (4,'Lijadora',40000),
                              (5,'Serrucho Electrico',50000);
							  
INSERT into cliente VALUES('22222222-2','Juan Perez','j.perez@mail.com','1 Calle Uno',2222222222),
                          ('33333333-3','Juanita Sánches','j.sanches@mail.com','2 Calle Dos',3333333333),
                          ('44444444-4','Marcelo Ugarte','m.ugarte@mail.com','3 Calle Tres',4444444444);							

INSERT into arriendo VALUES(1,'12/11/22',5,20000,'Eficacia en 5 dias o menos',2,'22222222-2'),
                           (2,'12/11/22',2,30000,'Eficacia en 2 dias o menos',3,'22222222-2'),
                           (3,'12/11/22',1,40000,'Eficacia en 1 dia',4,'33333333-3'),
                           (4,'12/11/22',3,40000,'Eficacia en solo 3 dias',4,'33333333-3');

SELECT * FROM arriendo;
SELECT * FROM cliente;



-- 1.	Inserte los datos de una empresa.
INSERT into empresa VALUES('11111111-1','Arrienda Herramientas','0123 Avenida Real',1234567890,'datosarriendo@herramientas.es','arrimientas.es');

-- 2.	Inserte 5 herramientas.
INSERT into herramienta VALUES(1,'Taladro Electrico',10000),
							  (2,'Cierra Electrica',20000),
							  (3,'Pistola de Clavos',30000),
							  (4,'Lijadora',40000),
							  (5,'Serrucho Electrico',50000);

-- 3.	Inserte 3 clientes.
INSERT into cliente VALUES('22222222-2','Juan Perez','j.perez@mail.com','1 Calle Uno',2222222222),
						  ('33333333-3','Juanita Sánches','j.sanches@mail.com','2 Calle Dos',3333333333),
						  ('44444444-4','Marcelo Ugarte','m.ugarte@mail.com','3 Calle Tres',4444444444);

-- 4.	Elimina el último cliente.
DELETE FROM cliente WHERE 'rut' = '44444444-4';

-- 5.	Elimina la primera herramienta.
DELETE FROM herramienta WHERE idherramienta = 1;

-- 6.	Inserte 2 arriendos para cada cliente. 
INSERT into arriendo VALUES(1,'12/11/22',5,20000,'Eficacia en 5 dias o menos',2,'22222222-2'),
						   (2,'12/11/22',2,30000,'Eficacia en 2 dias o menos',3,'22222222-2'),
						   (3,'12/11/22',1,40000,'Eficacia en 1 dia',4,'33333333-3'),
						   (4,'12/11/22',3,40000,'Eficacia en solo 3 dias',4,'33333333-3');
						   
-- 7.	Modifique el correo electrónico del primer cliente.
UPDATE cliente
SET correo = 'juan.p@mail.com'
WHERE rut = '22222222-2';

-- 8.	Liste todas las herramientas.
SELECT * FROM herramienta;

-- 9.	Liste los arriendos del segundo cliente.
SELECT * FROM arriendo WHERE cliente_rut = '33333333-3';

-- 10.	Liste los clientes cuyo nombre contenga una a.
SELECT * FROM cliente WHERE nombre LIKE '%a%';

-- 11.	Obtenga el nombre de la segunda herramienta insertada.
SELECT nombre FROM herramienta WHERE nombre LIKE '%a%';

-- 12.	Modifique los primeros 2 arriendos insertados con fecha 15/01/2020.
UPDATE arriendo
SET fecha = '01/15/2020'
WHERE folio = 1;

UPDATE arriendo
SET fecha = '01/15/2020'
WHERE folio = 2;

-- 13.	Liste Folio, Fecha y ValorDia de los arriendos de enero del 2020.
SELECT folio, fecha, valordia 
FROM arriendo
WHERE EXTRACT(MONTH FROM fecha) = 01 AND EXTRACT(YEAR FROM fecha)= 2020;